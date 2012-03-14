class CreatePayments < ActiveRecord::Migration
  def self.up
    create_table :payments do |t|
      t.integer :customer_id, :null => false
      t.string  :payment_reference, :null => false
      t.date    :payment_date
      t.string  :mode
      t.date    :check_date
      t.string  :ref_no
      t.float   :total_amount,   :default => 0.00, :null => false
      t.float   :amount_applied, :default => 0.00, :null => false
      t.text    :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :payments
  end
end
