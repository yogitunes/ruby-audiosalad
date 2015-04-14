module AudioSalad
  class Playlist < Base
    CONVERSION = {
      'artist playlist' => 'artist',
      'more releases' => 'more',
      'DJ-playlist' => 'dj',
      'site playlist' => 'site'
    };

    fields :key,:name,:sort_order,:ordered,:tags,:images,:texts,:item_type

    def id
      data['playlistId']
    end

    def items
      @items ||= data['items'].collect { |i| deref(i) }
    end

    def type
      CONVERSION[data['type']] || data['type']
    end

    def description
      texts.find { |t| t['type'] == 'Description' }['content'] rescue nil
    end

    private

    def deref item
      if(item["type"] == "track")
        AudioSalad::API.get_track_by_id item['id']
      else
        nil
      end
    end
  end
end
