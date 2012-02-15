class Adjustment < ActiveRecord::Base
  belongs_to :customer
  has_many :adjustment_details
end
