class AddClosedAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :closed_at, :datetime, default: :null
  end
end
