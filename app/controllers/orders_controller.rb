class OrdersController < ApplicationController
  before_filter :login_required
  before_filter :get_customers
  before_filter :get_products

  def first
a = "jello"
  end
  
  def index
    @orders = Order.find(:all, :conditions => ["delivered = false"], :include => [:customer], :order => "order_date ASC,customers.name ASC")
  end
  
  def show
    @order = Order.find_by_id(params[:id], :include => [:customer])
    if @order
      @order_details = OrderDetail.find(:all, :conditions => ["order_id = ?",  @order.id], :include => [:product], :order => "products.name ASC")
      @new_detail    = @order.order_details.new
    end
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "show.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "OS #{@order.id}.pdf", :type => 'application/pdf')
        return
      }
    end
  end
  
  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(params[:order])
    if @order.save
      redirect_to order_url(@order), :notice => "Order added successfully."
    else
      render :action => 'new', :status => :unprocessable_entity
    end
  end
  
  def edit
    @order = Order.find_by_id(params[:id])
  end
  
  def update
    @order = Order.find_by_id(params[:id])
    if @order.update_attributes(params[:order])
      redirect_to orders_url, :notice => "Order successfully updated." 
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @order = Order.find_by_id(params[:id])
    if @order.destroy
      flash[:notice] = "Successfully deleted order"
    else
      flash[:error] = "Error in deleting order"
    end
    redirect_to orders_url
  end

  def payments
    @orders = Order.all_unpaid
  end

  def paid
    @orders = Order.all_paid
  end

  def deliver
    order = Order.find_by_id(params[:id])
    if order
      order.deliver_now
      flash[:notice] = "Order delivered"
      redirect_to orders_url
    end
  end

  def pay_now
    order = Order.find_by_id(params[:id])
    if order
      order.pay_now
      flash[:notice] = "Payment made"
      redirect_to payments_url
    end
  end
  
end
