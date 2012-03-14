class CreatePaymentDetails < ActiveRecord::Migration
  def self.up
    create_table :payment_details do |t|
      t.integer :payment_id, :null => false
      t.integer :customer_id,:null => false
      t.integer :order_id,   :null => false
      t.float   :amount,     :null => false, :default => 0.00
      t.text :notes

      t.timestamps
    end
  end
  def self.down
    drop_table :payment_details
  end
end
