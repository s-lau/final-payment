class AddEventCompensation < ActiveRecord::Migration
  def change
    create_table :event_compensations do |t|
      t.belongs_to :user
      t.belongs_to :event
      t.timestamps
    end
  end
end
