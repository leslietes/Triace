class CreatePoDetails < ActiveRecord::Migration
  def self.up
    create_table :po_details do |t|
      t.integer :po_id
      t.integer :quantity
      t.string  :unit
      t.integer :product_id
      t.decimal :case_price, :precision => 12, :scale => 2, :default => 0.00
      t.timestamps
    end
  end
  def self.down
    drop_table :po_details
  end
end
