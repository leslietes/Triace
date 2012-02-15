class AddDefaultToDecimalFields < ActiveRecord::Migration
  def change
    execute "ALTER TABLE delivery_details CHANGE distributors_price distributors_price DECIMAL(12,2) default 0.00"
    execute "ALTER TABLE deliveries CHANGE total_amount total_amount DECIMAL(12,2) default 0.00"
    execute "ALTER TABLE products CHANGE distributors_price distributors_price DECIMAL(12,2) default 0.00"
    execute "ALTER TABLE order_details CHANGE unit_price unit_price DECIMAL(12,2) default 0.00"
  end
end
