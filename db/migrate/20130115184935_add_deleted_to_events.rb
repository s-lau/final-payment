class AddDeletedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :trashed, :boolean, default: false
    add_column :events, :trashed_at, :timestamp, null: true, default: :null
  end
end
