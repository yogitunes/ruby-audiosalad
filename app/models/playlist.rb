require_dependency GenericMusicRails::Engine.root.join('app','models','playlist').to_s

Playlist.class_eval do
  def self.read_audiosalad(as_playlist)
    playlist = Playlist.where(audiosalad_playlist_id: as_playlist.id).first_or_create
    playlist.read_audiosalad(as_playlist)
  end

  def snap(durations,duration)
    closest_duration = nil
    closest_distance = nil

    durations.each do |d|
      dist = (d*60-duration).abs
      if(closest_distance==nil || dist < closest_distance)
        closest_distance = dist
        closest_duration = d
      end
    end

    closest_duration
  end

  def read_audiosalad(playlist)
    self.name = playlist.name
    self.type_name = playlist.type
    self.description = playlist.description
    self.creator = Profile.for_name playlist.key
    save

    track_hashes = playlist.data['items'].reject { |i| i['type'] != 'track' }
    track_ids = track_hashes.collect { |t| t['id'] }
    tracks = track_ids.collect { |id| Track.import_from_audiosalad(id,{ update_existing: false }) }
    
    mixes = tracks.reject { |t| (t.album.record_label.name != "Yogi Tunes Mixes") rescue true }
    tracks = tracks - mixes
    
    self.set_ordered_tracks tracks

    if playlist.data['images'].length && (!playlist.cover ||!playlist.cover.image || !playlist.cover.image.url)
      playlist.covers.destroy_all
      c = Cover.new
      c.remote_image_url = playlist.data['images'][0]['urlLarge']
      c.coverable = playlist
      c.save

      playlist.reload
    end
    
    mixes.each do |mix_track|
      duration = snap([30,60,75,90],mix_track.duration)
      mix = self.mixes.where(duration: duration).first_or_create
      mix.mix_tracks = [mix_track]
      mix.audiosalad_release_id = mix_track.album.audiosalad_release_id

      unless self.cover
        self.cover = Cover.create(image: mix_track.album.cover.image)
      end

      mix.save
    end

    self
  end
end
