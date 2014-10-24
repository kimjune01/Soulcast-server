class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :content
      t.belongs_to :video, index: true
      t.references :user

      t.timestamps null: false
    end
  end
end
