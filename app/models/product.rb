class Product < ActiveRecord::Base
  has_many :delivery_details
  has_many :order_details
  has_many :inventories#, :conditions => ["closed = false"]
  has_many :adjustment_details
  has_many :notes
  has_many :po_details

  # order_details - delete
  def self.recalculate_inventory(product)
    p = find_by_id(product)
    inventories = p.inventories

    if inventories.empty?
      count = 0
    else
      count = 0
      inventories.each do |i|
        count = count + i.item_in - i.item_out
      end
    end

    p.update_balance(count) if p.balance != count
  end

  def self.total_inventory
    sum("balance * distributors_price")
  end
  
  # for order new/create
  def self.update_balance(product,balance)
    p = find_by_id(product)
    if p
      p.balance = balance
      p.save!
    end
  end

  def self.find_balance(product)
    p = find_by_id(product)
    if p
      return p.balance
    end
    return 0
  end
  
  #def self.add_product(product,quantity)
  #  p = find_by_id(product)
  #  if p
  #    p.balance = p.balance + quantity
  #    p.save!
  #  end
  #end

  # for order edit/update - quantity changed
  #def self.deduct_balance(product,quantity)
  #  p = find_by_id(product)
  #  if p
  #    p.balance = p.balance - quantity
  #    p.save!
  #  end
  #end

  def update_balance(balance)
    self.balance = balance
    self.save!
  end

end
