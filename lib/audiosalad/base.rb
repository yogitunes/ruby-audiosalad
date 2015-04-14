module AudioSalad
  class Base
    attr_accessor :data

    def self.with_data data
      r = self.new
      r.data = data
      r
    end

    def to_s
      "#{ self.class.name }<#{ id }>"
    end

    def self.fields(*fields)
      fields.each do |f|
        self.class_eval <<-eos
      def #{ f.to_s }
        data['#{f.to_s}']
      end
      eos
      end

    end
  end
end




