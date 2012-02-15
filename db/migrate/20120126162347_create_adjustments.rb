class CreateAdjustments < ActiveRecord::Migration
  def self.up
    create_table :adjustments do |t|
      t.integer :customer_id
      t.date    :adjustment_date
      t.decimal :total_amount, :precision => 12, :scale => 2, :default => 0.00
      t.string  :explanation
      
      t.timestamps
    end
  end
  def self.down
    drop_table :adjustments
  end
end
