class ChangeProductCasePrice < ActiveRecord::Migration
  def change
    execute "ALTER TABLE products CHANGE wholesale_price wholesale_price DECIMAL(12,2) default 0.00"
  end

end
