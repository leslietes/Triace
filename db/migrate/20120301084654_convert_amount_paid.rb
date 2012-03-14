class ConvertAmountPaid < ActiveRecord::Migration
  def change
    execute "ALTER TABLE payments CHANGE total_amount total_amount DECIMAL(12,2) default 0.00"
    execute "ALTER TABLE payments CHANGE amount_applied amount_applied DECIMAL(12,2) default 0.00"
    execute "ALTER TABLE payment_details CHANGE amount amount DECIMAL(12,2) default 0.00"
  end
end
