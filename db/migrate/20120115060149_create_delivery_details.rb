class CreateDeliveryDetails < ActiveRecord::Migration
  def self.up
    create_table :delivery_details do |t|
      t.integer :delivery_id,    :null => false
      t.integer :quantity,       :null => false
      t.string  :unit,           :null => false
      t.integer :product_id,     :null => false
      t.integer :count_per_pack, :null => false
      t.decimal :distributors_price
      t.timestamps
    end
  end
  
  def self.down
    drop_table :delivery_details
  end
end
