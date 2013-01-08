class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.text :text
      t.references :event
      t.belongs_to :user

      t.timestamps
    end
  end
end
