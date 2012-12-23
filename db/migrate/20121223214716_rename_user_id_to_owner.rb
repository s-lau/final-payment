class RenameUserIdToOwner < ActiveRecord::Migration
  def up
    rename_column :events, "user_id", "owner"
  end

  def down
    rename_column :events, "owner", "user_id"
  end
end
