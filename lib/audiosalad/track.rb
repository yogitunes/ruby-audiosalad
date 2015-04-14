module AudioSalad
  class Track < Base
    fields :id,:discnum,:tracknum,:title,:artist,:isrc,:length

    def release_id
      data['releaseId']
    end
    
  end
end
