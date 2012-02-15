class DeliveryDetail < ActiveRecord::Base
  belongs_to :delivery
  belongs_to :product
  
  after_create :update_inventory, :update_delivery_total
  #after_update :update_product_count
  
  protected
  
  def update_delivery_total
    total = self.quantity * self.distributors_price
    
    delivery = self.delivery
    delivery.total_amount = delivery.total_amount +  total
    delivery.delivery_detail_count = delivery.delivery_detail_count + 1
    
    delivery.save
  end
  
  def update_inventory
    product = self.product_id
    item_in = self.quantity
    item_out= 0
    dr_no   = "DR ##{self.delivery.delivery_number}"

    #latest = Inventory.find_last(product)
    #beg_balance = (latest.nil? ? 0 : latest.balance)
    
    product_balance = Product.find_balance(product)

    beg_balance = product_balance
    balance     = beg_balance + item_in
    
    Inventory.add_new(dr_no,product,beg_balance,item_in,item_out)
    Product.update_balance(product,balance)
  end
end
