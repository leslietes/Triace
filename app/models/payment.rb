class Payment < ActiveRecord::Base
  belongs_to :customer
  has_many :payment_details

  def apply(amount)
    self.amount_applied += amount
    self.save!
  end

  def refund(amount)
    self.amount_applied -= amount
    self.save!
  end

  def excess
    self.total_amount - self.amount_applied
  end

  def not_fully_applied?
    self.total_amount > self.amount_applied
  end

  
end
