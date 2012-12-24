class CreateEventComments < ActiveRecord::Migration
  def change
    create_table :event_comments do |t|
      t.text :text
      t.string :event_uuid, :limit => 36
      t.belongs_to :user

      t.timestamps
    end
  end
end
