require_dependency GenericMusicRails::Engine.root.join('app', 'models', 'album').to_s

class Album

  def self.bigfile(url,&block)
    uri = URI(url)
    the_file = Tempfile.new('big-uri-dl')
    the_file.binmode
    
    begin
      Rails.logger.info "Downloading cover art: #{ url }"
#      the_file.write HTTParty.get(url).parsed_response
      Net::HTTP.start(uri.host,uri.port) do |http|
        request = Net::HTTP::Get.new uri.request_uri
        http.request request do |response|
          response.read_body do |chunk|
            the_file.write chunk
          end
        end
      end
    rescue StandardError => x
      Rails.logger.error "Error during file download: #{x}"
      the_file.close
      the_file.unlink

      return nil
    end
      
    the_file.rewind
    block.call(the_file)
    the_file.close
    the_file.unlink

    return true
  end
    
  def self.import_from_audiosalad(release_id, options={})
    release = AudioSalad::API.get_release_by_id self.audiosalad_release_id
    album = Album.where(audiosalad_release_id: release_id.to_i).first_or_create
    album.read_audiosalad options
  end

  def read_audiosalad(release=nil,options={})
    release ||= AudioSalad::API.get_release_by_id self.audiosalad_release_id
    album = self
    album.name = release.title
    album.artist = Profile.for_name(release.artist)
    album.record_label = RecordLabel.for_name(release.label)

    cover_url = release.front_cover[:url] rescue ''
    
    # if album.covers.length == 0 || options[:force_cover]==true
    #   
    #   Rails.logger.info("Error doing cover") unless (Album.bigfile(cover_url) do |file|
    #                                                    Rails.logger.info "Cover: #{ file }"
    #                                                    album.cover = file
    #                                                  end)
    # end

    album.tmp_cover_url = cover_url
    
    if options[:skip_tracks] != true
      # blow away the track list, we'll recreate it from audiosalad:
      album.track_locations.delete_all

      i = 1
      release.tracks.each do |t|
        t = Track.from_audiosalad(t)
        TrackLocation.create({ track: t , location: album , placement: i })
        i = i+1
      end
    end
    
    album.save
    album
    
  end
  
end
