class Inventory < ActiveRecord::Base
  belongs_to :product
  def self.find_last(product)
    find(:first, :conditions => ["product_id = ?", product], :order => "id DESC")
  end
  
  def self.add_new(dr_no,product,beg_balance,item_in,item_out)
    Inventory.create(:delivery_number => dr_no,
                     :product_id      => product,
                     :beg_balance     => beg_balance,
                     :item_in         => item_in,
                     :item_out        => item_out,
                     :balance         => beg_balance + item_in - item_out)
    
  end

  def self.find_entry(dr_no,product,quantity)
    find(:first, :conditions => ["delivery_number = ? and product_id = ? and item_out = ?", dr_no, product, quantity])
  end


  def self.remove_entry(dr_no,product,quantity)
    inv = find(:first, :conditions => ["delivery_number = ? and product_id = ? and item_out = ?", dr_no, product, quantity])
    inv.delete if inv
  end

  def update_entry(product,quantity)
    self.product_id = product
    self.item_out = quantity
    self.save
  end

#def self.update_inventory(dr_no,product,item_in,item_out)
#  inv = find(:first, :conditions => ["delivery_no = ? and product_id = ?", dr_no, product])
#  if inv
#    inv.item_in = item_in
#    inv.item_out= item_out
#    inv.balance = inv.beg_balance + item_in - item_out
#    inv.save!
#  end
#end

  def close
    self.closed = true
    self.date_closed = Date.today
    self.save!
  end

end
