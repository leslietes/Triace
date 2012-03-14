class Customer < ActiveRecord::Base
  has_many :orders
  has_many :adjustments
  has_many :payments
  has_many :payment_details
  
 # def unpaid_orders
 #   Order.unpaid_by(id)
 # end

  def address
    address = []
    address << [address1] if !address1.blank?
    address << [address2] if !address2.blank?
    address << [city]     if !city.blank?
    address << [province] if !province.blank?
    address << [region]   if !region.blank?
    address << [zip_code] if !zip_code.blank?
    address.join(", ")
  end
end
