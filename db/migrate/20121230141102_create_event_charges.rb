class CreateEventCharges < ActiveRecord::Migration
  def change
    create_table :event_charges do |t|
      t.string :name
      t.money :price
      t.string :event_uuid, :limit => 36
      t.references :user

      t.timestamps
    end
    add_index :event_charges, :event_uuid
    add_index :event_charges, :user_id
  end
end
