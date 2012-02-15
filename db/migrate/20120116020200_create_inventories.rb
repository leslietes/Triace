class CreateInventories < ActiveRecord::Migration
  def self.up
    create_table :inventories do |t|
      t.string  :delivery_number
      t.string  :product_id
      t.integer :beg_balance, :default => 0
      t.integer :item_in,     :default => 0
      t.integer :item_out,    :default => 0
      t.integer :balance,     :default => 0
      t.string  :details
      t.timestamps
    end
  end
  def self.down
    drop_table :inventories
  end
end
