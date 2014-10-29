class AddJobIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :jobID, :string
  end
end
