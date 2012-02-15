class Delivery < ActiveRecord::Base
  has_many :delivery_details

  def self.update_total(dr_no,old_subtotal,new_subtotal)
    dr = find_by_id(dr_no)
    if dr
      dr.total_amount = dr.total_amount - old_subtotal + new_subtotal
      dr.save!
    end
  end
end
