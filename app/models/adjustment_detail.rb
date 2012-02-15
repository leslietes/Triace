class AdjustmentDetail < ActiveRecord::Base
  belongs_to :adjustment
  belongs_to :product

  after_create :update_inventory, :update_adjustment_total
  
  def update_adjustment_total
    total = (self.quantity_in - self.quantity_out) * self.unit_price
    
    adjustment = self.adjustment
    adjustment.total_amount = adjustment.total_amount +  total
    
    adjustment.save
  end
  
  def update_inventory
    product = self.product_id
    item_in = self.quantity_in
    item_out= self.quantity_out
    dr_no   = "Adj ##{self.adjustment.id}"

    product_balance = Product.find_balance(product)

    beg_balance = product_balance
    balance     = beg_balance + item_in - item_out
    
    Inventory.add_new(dr_no,product,beg_balance,item_in,item_out)
    Product.update_balance(product,balance)
  end
end
