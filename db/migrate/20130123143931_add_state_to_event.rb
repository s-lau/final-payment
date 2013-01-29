class AddStateToEvent < ActiveRecord::Migration
  def change
    add_column :events, :state, :string
    add_index :events, :state
  end
end
