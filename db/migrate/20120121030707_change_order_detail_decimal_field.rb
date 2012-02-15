class ChangeOrderDetailDecimalField < ActiveRecord::Migration
  def up
	execute "ALTER TABLE delivery_details CHANGE distributors_price distributors_price DECIMAL(12,2)"
  end

  def down
	execute "ALTER TABLE delivery_details CHANGE distributors_price distributors_price DECIMAL(10,0)"
  end
end
