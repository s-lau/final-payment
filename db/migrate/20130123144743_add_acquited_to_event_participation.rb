class AddAcquitedToEventParticipation < ActiveRecord::Migration
  def change
    add_column :event_participations, :acquited, :boolean, :default => false
  end
end
