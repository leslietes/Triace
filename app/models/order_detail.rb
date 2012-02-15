class OrderDetail < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  
  after_create  :update_inventory
  after_save    :update_order_total
  after_update  :check_inventory_entry
  after_destroy :remove_inv_entry, :update_order_total
  
  protected

  def check_inventory_entry
    if self.changed?
      old_qty = quantity_was
      old_prod= product_id_was

      new_qty = quantity
      new_prod= product_id

      inv = Inventory.find_entry("OS ##{self.order.id}",old_prod,old_qty)
      inv.update_entry(new_prod,new_qty)

      Product.recalculate_inventory(new_prod)
      Product.recalculate_inventory(old_prod) if old_prod != new_prod
    end
  end
  
  def update_order_total
    total = 0
    order = self.order
    details= order.order_details

    details.each do |d|
      total = total + (d.quantity * d.unit_price)
    end

    order.total_amount = total
    order.save
  end
    
  def update_inventory
    product = self.product_id
    item_out= self.quantity
    item_in = 0
    os_no   = "OS ##{self.order.id.to_s}"
    
    #latest = Inventory.find_last(product)
    #beg_balance = latest.balance 

    product_balance = Product.find_balance(product)

    beg_balance = product_balance
    balance     = beg_balance - item_out
    
    Inventory.add_new(os_no,product,beg_balance,item_in,item_out)
    Product.update_balance(product,balance)
  end

  def remove_inv_entry
    Inventory.remove_entry("OS ##{self.order.id}",self.product_id,self.quantity)
    Product.recalculate_inventory(self.product_id)
  end

end
