require_dependency GenericMusicRails::Engine.root.join('app', 'models', 'album').to_s

class Album
  def self.import_from_audiosalad(release_id, options={})
    release = AudioSalad::API.get_release_by_id release_id
    album = Album.where(audiosalad_release_id: release_id.to_i).first_or_create
    album.read_audiosalad release, options
  end

  def read_audiosalad(release=nil,options={})
    release ||= AudioSalad::API.get_release_by_id self.audiosalad_release_id
    
    if release==nil
      self.available = false
      self.save
      return
    end

    album = self
    album.name = release.title
    album.artist = Profile.for_name(release.artist)
    album.record_label = RecordLabel.for_name(release.label)
    album.release_date = release.release_date

    album.audiosalad_cache = release.data.except('tracks').to_json

    # dumbest way to get text data:
    begin
      album.description = release.data['texts'][0]['content']
    rescue
    end  

    cover_url = release.front_cover[:url] rescue ''
    
    # if album.covers.length == 0 || options[:force_cover]==true
    #   
    #   Rails.logger.info("Error doing cover") unless (Album.bigfile(cover_url) do |file|
    #                                                    Rails.logger.info "Cover: #{ file }"
    #                                                    album.cover = file
    #                                                  end)
    # end

    album.tmp_cover_url = cover_url
    if !album.cover || !album.cover.image || !album.cover.image.url
      album.covers.destroy_all
      c = Cover.new
      c.remote_image_url = cover_url
      c.coverable = album
      c.save
    end
    
    if options[:skip_tracks] != true
      tracks = release.tracks.collect {|t| Track.from_audiosalad(t) }
      # blow away the track list, we'll recreate it from audiosalad:
      tracks.each { |t| t.album = album; t.save }
      self.set_ordered_tracks(tracks)
    end
    
    album.save
    album
    
  end
  
end
