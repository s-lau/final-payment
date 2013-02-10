class AddSentReceivedFlagsToEventCompensation < ActiveRecord::Migration
  def change
    add_column :event_compensations, :sent, :boolean
    add_column :event_compensations, :received, :boolean
    add_index  :event_compensations, [:user_id, :event_id], unique: true
  end
end
