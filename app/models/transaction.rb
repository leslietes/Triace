class Transaction < ActiveRecord::Base
  belongs_to :department
  belongs_to :subdepartment
  belongs_to :account
  belongs_to :payee
  belongs_to :user
  
  validates :_date,         :presence => true
  
  validates :department_id, :presence => true
  
  validates :account_id,    :presence => true
  
  validates :payee_id,      :presence => true
  
  validates :amount,        :presence => true,      :numericality => true 
  
  validates :payment_of,    :presence => true
end
