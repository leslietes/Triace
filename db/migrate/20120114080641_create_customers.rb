class CreateCustomers < ActiveRecord::Migration
  def self.up
    create_table :customers do |t|
      t.string :name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :province
      t.string :region
      t.string :zip_code
      t.string :contact_no
      t.string :fax_no
      t.string :mobile_no
      t.string :contact_person
      t.string :terms
      t.string :details
      t.timestamps
    end
  end
  def self.down
    drop_table :customers
  end
end
