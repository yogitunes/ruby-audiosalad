require_dependency GenericMusicRails::Engine.root.join('app', 'models', 'track').to_s

class Track
  def self.from_audiosalad salad
    t = Track.where(audiosalad_track_id: salad.id).first_or_create
      
    t.name = salad.title
    t.artist_string = salad.artist
    t.duration = salad.length
    t.isrc = salad.isrc
    
    t.reporting_metadata = salad.data

    t.save
    
    t
  end
end

