class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer    :customer_id
      t.date       :order_date
      t.decimal    :total_amount, :precision => 9, :scale => 2, :default => 0.00
      t.string     :terms
      t.boolean    :delivered, :default => false
      t.date       :delivered_date
      t.string     :comments
      t.timestamps
    end
  end
  def self.down
    drop_table :orders
  end
end
