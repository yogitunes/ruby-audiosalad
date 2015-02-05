module AudioSalad
  class API
    def self.key
      AudioSalad::Config.key
    end

    def self.profile
      AudioSalad::Config.profile
    end
    
    def self.base
      AudioSalad::Config.base
    end

    def self.get_release_by_id(release_id)
      Release.with_data(self.retrieve("releaseId", release_id)[0])
    end

    def self.get_track_by_id(track_id)
      Track.with_data(self.retrieve("trackId",track_id)[0])
    end

    @private
    def self.retrieve(method_name,argument=nil)
      if(argument)
        method_string = "#{ method_name }=#{argument}"
      else
        method_string = method_name
      end

      uri = "#{ self.base }/fetch.php?k=#{ self.key }&g_profile=#{ self.profile }&#{method_string}"

      response = HTTParty.get(uri)

      raise response unless response.code == 200

      ActiveSupport::JSON.decode(response.body)
    end
  end
end
