class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_key
      t.integer :epoch
      t.string :vanity
      t.string :hls
      t.string :webm
      t.string :title
      t.integer :message_id
      t.integer :user_id
      t.boolean :public_shared, :default => false
      t.boolean :transcoded, :default => false

      t.timestamps null: false
    end
    add_index :videos, :message_id
    add_index :videos, :user_id
  end
end
