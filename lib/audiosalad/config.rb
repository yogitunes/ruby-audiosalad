module AudioSalad
  module Config
    class << self
      
      def key(val=nil)
        if(val)
          @key = val
        else
          raise "No key specified, create config/initializers/audiosalad.rb and define the key" unless @key
          @key
        end
      end

      def profile(val=nil)
        if(val)
          @profile = val
        else
          raise "No profile specified, create config/initializers/audiosalad.rb and define the key" unless @key
          @profile
        end
      end

      def base(val=nil)
        if(val)
          @base = val
        else
          @base || "http://api.audiosalad.com"
        end
      end
      
    end
  end
end
