class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description

      t.belongs_to :user

      t.timestamps
    end
  end
end
