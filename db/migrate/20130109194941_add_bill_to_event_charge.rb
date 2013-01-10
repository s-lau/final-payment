class AddBillToEventCharge < ActiveRecord::Migration
  def change
    add_column :event_charges, :bill, :string
  end
end
