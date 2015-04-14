require_dependency GenericMusicRails::Engine.root.join('app', 'models', 'track').to_s

class Track
  def self.import_from_audiosalad(track_id,options={})
    salad = AudioSalad::API.get_track_by_id(track_id)
    return self.from_audiosalad(salad)
  end
  
  def read_audiosalad(salad=nil,options={})
    raise "Need track ID or salad object" if not salad and not self.audiosalad_track_id
    salad = AudioSalad::API.get_track_by_id(self.audiosalad_track_id) if not salad
    
    self.name = salad.title
    self.artist_string = salad.artist
    self.duration = salad.length
    self.isrc = salad.isrc
    
    self.reporting_metadata = salad.data

    self.save
    
    self
  end
  
  def self.from_audiosalad(salad,options={})
    t = Track.where(audiosalad_track_id: salad.id).first_or_initialize
    if(!(options.has_key? :update_existing) || options[:update_existing] != false)
      t.read_audiosalad(salad,options)
    end
  end
end

