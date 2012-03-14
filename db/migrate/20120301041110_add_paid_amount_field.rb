class AddPaidAmountField < ActiveRecord::Migration
  def up
    add_column :orders, :amount_paid, :decimal, :precision => 12, :scale => 2, :default => 0.00
  end

  def down
    remove_column :orders, :amount_paid
  end
end
