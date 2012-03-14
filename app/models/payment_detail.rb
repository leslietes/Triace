class PaymentDetail < ActiveRecord::Base
belongs_to :payment
  belongs_to :customer
  belongs_to :order

 def remove
    self.destroy
  end

end
