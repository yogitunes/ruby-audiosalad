module AudioSalad
  class Release
    attr_accessor :data,:tracks
    FIELDS = :upc,:title,:version,:artist,:label

    FIELDS.each do |f|
      self.class_eval <<-eos
      def #{ f.to_s }
        data['#{f.to_s}']
      end
      eos
    end

    def self.with_data data
      r = Release.new
      r.data = data
      r.tracks = data['tracks'].collect { |d| Track.with_data d }
      r
    end

    def to_s
      "release<#{ id }>"
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
