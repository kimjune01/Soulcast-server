class AddRecipientsToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :recipient, :string
  end
end
