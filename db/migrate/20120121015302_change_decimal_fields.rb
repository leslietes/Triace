class ChangeDecimalFields < ActiveRecord::Migration
  def up
	execute "ALTER TABLE order_details CHANGE unit_price unit_price DECIMAL(12,2)"
  end

  def down
	execute "ALTER TABLE order_details CHANGE unit_price unit_price DECIMAL(5,2)"
  end
end
