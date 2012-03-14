class CreatePos < ActiveRecord::Migration
  def self.up
    create_table :pos do |t|
      t.date    :po_date
      t.decimal :total_amount, :precision => 12, :scale => 2, :default => 0.00
      t.string  :note
      t.timestamps
    end
  end

  def self.down
    drop_table :pos
  end
end
