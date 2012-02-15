class CreateOrderDetails < ActiveRecord::Migration
  def self.up
    create_table :order_details do |t|
      t.integer :order_id
      t.integer :quantity
      t.string  :unit
      t.integer :product_id
      t.decimal :unit_price, :precision => 5, :scale => 2, :default => 0.00
      t.timestamps
    end
  end
  def self.down
    drop_tables :order_details
  end
end
