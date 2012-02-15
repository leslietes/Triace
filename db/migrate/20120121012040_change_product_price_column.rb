class ChangeProductPriceColumn < ActiveRecord::Migration
  def up
	execute "ALTER TABLE products CHANGE distributors_price distributors_price DECIMAL(12,2)"
  end

  def down
	change_column :products, :distributors_price, :decimal, :precision => 5, :scale => 2, :default => 0.00
  end
end
