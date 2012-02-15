class AddPaidField < ActiveRecord::Migration
  def self.up
    add_column :orders, :paid,     :boolean, :default => false
    add_column :orders, :pay_date, :date
  end

  def self.down
    drop_column :orders, :paid
    drop_column :orders, :pay_date
  end
end
