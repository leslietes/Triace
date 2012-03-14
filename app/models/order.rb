class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :order_details, :dependent => :destroy
  belongs_to :payment_details

  def self.all_unpaid
    Order.find(:all, :conditions => ["delivered = true and paid = false"], :include => [:customer])
  end

  def self.all_paid
    Order.find(:all, :conditions => ["delivered = true and paid = true"], :include => [:customer])
  end

  def self.unpaid_by(customer)
    Order.find(:all, :conditions => ["delivered = true and paid = false and customer_id = ?", customer], :include => [:customer])
  end
  
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

  def pay_now(amount=0)
    self.amount_paid = self.amount_paid + amount
    self.paid = true if self.amount_paid == self.total_amount
    self.pay_date = Date.today
    self.save
  end

  def refund(amount)
    self.amount_paid = self.amount_paid - amount
    self.paid = false
    self.pay_date = nil
    self.save!
  end

  def pending_payment
    self.total_amount - self.amount_paid
  end
end
