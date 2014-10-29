class AddFromIdToIdToUsers < ActiveRecord::Migration
  def change
  	add_column :messages, :from_id, :integer
  	add_column :messages, :to_id, :integer

  	add_index :messages, :from_id
  	add_index :messages, :to_id
  end
end
