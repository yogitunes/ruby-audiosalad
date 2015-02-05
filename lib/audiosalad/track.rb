module AudioSalad
  class Track
    attr_accessor :data
    
    FIELDS = [:id,:discnum,:tracknum,:title,:artist,:isrc,:length]

    FIELDS.each do |f|
      self.class_eval <<-eos
      def #{ f.to_s }
        data['#{f.to_s}']
      end
      eos
    end

    def release_id
      data['releaseId']
    end
    
    def self.with_data data
      t = Track.new
      t.data = data
      t
    end
  end
end
