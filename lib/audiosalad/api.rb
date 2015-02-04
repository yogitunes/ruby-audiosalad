module AudioSalad
  class API
    def key
      '9D626C2C137EC2DE36CC12FFA78F3115E9A157126CE74F4F845034F7CF3F4056'
    end

    def profile
      'yogitunes.audiosalad.com'
    end
    
    def base
      'http://api.audiosalad.com'
    end

    def get_release_by_id(release_id)
      retrieve 'releaseId', release_id
    end

    @private
    def retrieve(method_name,argument=nil)
      if(argument)
        method_string = "#{ method_name }=#{argument}"
      else
        method_string = method_name
      end
      
      response = HTTParty.get('#{ base }/fetch.php?k=#{ key }&#{method_string}')

      raise response unless response.code == 200

      ActiveSupport::JSON.decode(response.body)
    end
  end
end
