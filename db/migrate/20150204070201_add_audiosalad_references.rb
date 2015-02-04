class AddAudiosaladReferences < ActiveRecord::Migration
  def change
    add_column :tracks, :audiosalad_track_id, :integer
    add_column :playlists, :audiosalad_playlist_id, :integer
    add_column :albums, :audiosalad_release_id, :integer
    add_column :record_labels, :audiosalad_label_id, :integer
    add_column :profiles, :audiosalad_artist_id, :integer
  end
end
