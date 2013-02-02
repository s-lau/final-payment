class AddCompensatedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :compensated, :boolean, default: :null
    add_column :events, :compensated_at, :datetime, default: :null
  end
end
