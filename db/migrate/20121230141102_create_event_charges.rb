class CreateEventCharges < ActiveRecord::Migration
  def change
    create_table :event_charges do |t|
      t.string :name
      t.money :price
      t.references :event
      t.references :user

      t.timestamps
    end
    add_index :event_charges, :event_id
    add_index :event_charges, :user_id
  end
end
