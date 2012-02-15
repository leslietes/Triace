class HomeController < ApplicationController
def index
  if !logged_in?
    redirect_to login_url
  else
    @inv = Product.total_inventory 

    @order = Order.pending_deliveries
    #@orders = Order.find(:all, :conditions => ["delivered = false"], :include => [:customer], :order => "order_date ASC,customers.name ASC")

    @payment = Order.pending_payments
    #@payments = Order.find(:all, :conditions => ["delivered = true and paid = false"], :include => [:customer])
  end
end
end
