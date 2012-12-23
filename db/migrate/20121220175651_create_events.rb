class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events, id: false, primary_key: "uuid" do |t|
      t.string :uuid, :limit => 36, :primary => true
      t.string :name
      t.text :description

      t.belongs_to :user

      t.timestamps
    end
  end
end
