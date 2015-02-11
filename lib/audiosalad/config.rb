module AudioSalad
  module Config
    class << self
      def username(val=nil)
        if(val)
          @username = val
        else
          raise "No username specified, specify in config/initializers/audiosalad.rb" unless @username
          @username
        end
      end
      def password(val=nil)
        if(val)
          @password = val
        else
          raise "No password specified, specify in config/initializers/audiosalad.rb" unless @username
          @password
        end
      end
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
