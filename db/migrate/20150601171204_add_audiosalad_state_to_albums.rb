class AddAudiosaladStateToAlbums < ActiveRecord::Migration
  def change
    add_column :albums, :audiosalad_state, :string
  end
end
