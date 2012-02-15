class CreateProducts < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string :product_code
      t.string :name
      t.string :size
      t.integer :count_per_pack,    :default   => 1
      t.integer :balance,           :default   => 0
      t.decimal :distributors_price,:precision => 5, :scale => 2, :default => 0.00
      t.decimal :wholesale_price,   :precision => 5, :scale => 2, :default => 0.00
      t.decimal :srp,               :precision => 5, :scale => 2, :default => 0.00
      t.date    :expiry_date
      t.timestamps
    end
  end
  
  def self.down
    drop_table :products
  end
end
