class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description

      t.belongs_to :user
      t.boolean :closed, default: false
      t.timestamps
    end
  end
end
