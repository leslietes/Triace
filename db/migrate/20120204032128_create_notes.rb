class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes do |t|
      t.integer :quantity,   :default => 0
      t.string  :unit
      t.integer :product_id, :default => 0
      t.integer :amount ,    :default => 0.00, :precision => 12, :scale => 2     
      t.string  :explanation
      t.boolean :close,      :default => false
      t.date    :close_date
      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end
