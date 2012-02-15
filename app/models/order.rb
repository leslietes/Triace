class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :order_details
  
  def self.pending_deliveries
    sum("total_amount", :conditions => ["delivered = false"]) #, :include => [:customer], :order => "order_date ASC,customers.name ASC", :limit => 10)
  end

  def self.pending_payments
    sum("total_amount", :conditions => ["delivered = true and paid = false"]) #, :include => [:customer], :order => "order_date ASC,customers.name ASC", :limit => 10)
  end
  
  def deliver_now
    self.delivered = true
    self.delivered_date = Date.today
    self.save
  end

  def pay_now
    self.paid = true
    self.pay_date = Date.today
    self.save
  end
end
