class DeliveriesController < ApplicationController
  before_filter :get_products
  def index
    @deliveries = Delivery.all
  end
  
  def show
    #todo: include products
    @delivery = Delivery.find_by_id(params[:id])
    if @delivery
      @details = DeliveryDetail.find(:all, :conditions => ["delivery_id = ?", @delivery.id], :include => [:product], :order => "products.name ASC")
      #@details = @delivery.delivery_details.include[:products]
      @new_detail = @delivery.delivery_details.new
    end
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "show.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Delivery No #{@delivery.delivery_number} - #{@delivery.delivery_date}.pdf", :type => 'application/pdf')
        return
      }
    end
  end
  
  def new
    @delivery = Delivery.new
  end
  
  def create
    @delivery = Delivery.new(params[:delivery])
    if @delivery.save
      redirect_to delivery_url(@delivery), :notice => "Delivery added successfully."
    else
      render :action => 'new', :status => :unprocessable_entity
    end
  end
  
  def edit
    @delivery = Delivery.find_by_id(params[:id])
  end
  
  def update
    @delivery = Delivery.find_by_id(params[:id])
    if @delivery.update_attributes(params[:delivery])
      redirect_to deliveries_url, :notice => "Delivery successfully updated." 
    else
      render :action => 'edit'
    end
  end
  
  def delete
    
  end
  
end
