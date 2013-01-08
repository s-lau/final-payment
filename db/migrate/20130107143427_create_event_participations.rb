class CreateEventParticipations < ActiveRecord::Migration
  def change
    create_table :event_participations do |t|
      t.references :user
      t.references :event

      t.timestamps
    end
    add_index :event_participations, :user_id
    add_index :event_participations, :event_id
  end
end
