class CreateDeliveries < ActiveRecord::Migration
  def self.up
    create_table :deliveries do |t|
      t.string  :delivery_number
      t.date    :delivery_date
      t.integer :delivery_detail_count, :default => 0
      t.decimal :total_amount,          :precision => 7, :scale => 2, :default => 0.00
      t.string  :received_by
      t.string  :terms
      t.string  :details
      t.timestamps
    end
  end
  
  def self.down
    drop_table :deliveries
  end
end
