module AudioSalad
  class Release < Base
    attr_accessor :data,:tracks
    FIELDS = :upc,:title,:version,:artist,:label

    def tracks
      @tracks ||= data['tracks'].collect { |d| Track.with_data d }
    end
    
    def id
      data['releaseId']
    end

    def release_date
      if data['releaseDate'].presence
        Date.parse(data['releaseDate'])
      else
        nil
      end  
    end

    def front_cover
      d = data['images'].find { |m| m['type'].downcase == 'front' }

      # guarantee a reasonable url, with priority going to larger ones,
      # but give access to smaller ones:
      { url: d['urlLarge'] || d['urlMedium'] || d['urlSmall'],
       small: d['urlSmall'],
       medium: d['urlMedium'],
       large: d['urlLarge'] }
    end
  end
end
