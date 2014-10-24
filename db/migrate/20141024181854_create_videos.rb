class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :video_id
      t.integer :epoch
      t.references :user, index: true
      t.string :vanity
      t.string :hls
      t.string :webm
      t.string :title
      t.boolean :public_shared
      t.boolean :transcoded

      t.timestamps null: false
    end
  end
end
