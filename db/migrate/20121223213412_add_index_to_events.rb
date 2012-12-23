class AddIndexToEvents < ActiveRecord::Migration
  def up
    add_index :events, :uuid
  end
  def down
    remove_index :events, :uuid
  end
end
