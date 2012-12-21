class AddOwnerToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :owner, :user
  end
  def self.down
    remove_column :events, :owner
  end
end
