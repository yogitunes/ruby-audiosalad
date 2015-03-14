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

    def self.username
      AudioSalad::Config.username
    end

    def self.password
      AudioSalad::Config.password
    end
    
    def self.get_asid
      url = "#{ self.base }/auth.php?g_profile=#{ self.profile }&username=#{ self.username }&password=#{ self.password }"
      HTTParty.get(url).body
    end

    def self.clear
      url = "#{ self.base }/auth.php?g_profile=#{ self.profile }&clear"
      HTTParty.get(url).body
    end

    def self.download_track(track_id,hq=false,&block)
      file = Tempfile.new(['as_track','.mp3'])
      begin
        file.binmode
        url = downloadable_url(track_id,hq)
        file.write HTTParty.get(url).parsed_response
        block.call(file)
      ensure
        file.close
        file.unlink
      end
    end

    def self.downloadable_url(track_id,h1=false)
      clear
      "#{ self.base }/stream.php?g_profile=#{ self.profile }&id=#{ track_id }&asid=#{ get_asid }#{ hq ? '&hq' : '' }"
    end

    def self.get_release_by_id(release_id)
      response = self.retrieve("releaseId", release_id);
      if response
        Release.with_data(response[0])
      else
        nil
      end
    end

    def self.get_track_by_id(track_id)
      response = self.retrieve("trackId",track_id)
      if response
        Track.with_data(response[0])
      else
        nil
      end
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

      if response.code == 200
        ActiveSupport::JSON.decode(response.body)
      elsif response.body == "no matching objects found"
        nil
      else
        raise response unless response.code == 200
      end


    end
  end
end
