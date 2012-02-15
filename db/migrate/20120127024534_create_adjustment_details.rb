class CreateAdjustmentDetails < ActiveRecord::Migration
  def self.up
    create_table :adjustment_details do |t|
      t.integer :adjustment_id
      t.integer :quantity_in,  :default => 0
      t.integer :quantity_out, :default => 0
      t.string  :unit
      t.integer :product_id
      t.decimal :unit_price, :precision => 12, :scale => 2, :default => 0.00
      t.timestamps
    end
  end
  def self.down
    drop_table :adjustment_details
  end
end
