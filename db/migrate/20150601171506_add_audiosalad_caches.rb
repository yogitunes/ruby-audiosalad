class AddAudiosaladCaches < ActiveRecord::Migration
  def change
    add_column :albums, :audiosalad_cache, :text
    add_column :tracks, :audiosalad_cache, :text
    add_column :playlists, :audiosalad_cache, :text
  end
end
