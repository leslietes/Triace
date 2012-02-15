class Changeordertotalcolumn < ActiveRecord::Migration
  def up
    execute "ALTER TABLE deliveries CHANGE total_amount total_amount DECIMAL(12,2)"
    #change_column :orders, :total_amount, :decimal, :default => 0.00, :precision => 12, :scale => 2
  end

  def down
    change_column :orders,   :total_amount, 	  :decimal, :precision => 7, :scale => 2, :default => 0.00
  end
end
