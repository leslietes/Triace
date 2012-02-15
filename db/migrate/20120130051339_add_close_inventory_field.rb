class AddCloseInventoryField < ActiveRecord::Migration
  def up
    add_column :inventories, :closed,      :boolean, :default => false
    add_column :inventories, :date_closed, :date
  end

  def down
    remove_column :inventories, :closed
    remove_column :inventories, :date_closed
  end
end
