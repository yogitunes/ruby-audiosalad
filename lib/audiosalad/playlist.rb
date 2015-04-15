module AudioSalad
  class Playlist < Base
    CONVERSION = {
      'artist playlist' => 'artist',
      'more releases' => 'more',
      'site featured chart' => 'chart',
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
      t = texts.find { |t| t['type'] == 'Description' }
      t ||= text.find { |t| t['type'] == 'Other' }
      
      if t
        t['content']
      else
        nil
      end
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
