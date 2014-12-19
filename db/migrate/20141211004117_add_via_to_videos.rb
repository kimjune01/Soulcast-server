class AddViaToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :via, :string
  end
end
