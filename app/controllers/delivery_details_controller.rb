class DeliveryDetailsController < ApplicationController
  before_filter :get_products
  def create
    delivery = Delivery.find_by_id(params[:delivery_id])
    if delivery
      @detail = delivery.delivery_details.create(
		    :quantity   => params[:quantity],
 		    :unit	=> params[:unit],
 		    :product_id => params[:product_id],
 		    :distributors_price => params[:distributors_price],
                    :count_per_pack => params[:count_per_pack] )
      if @detail.save
        redirect_to delivery_url(delivery), :notice => "Detail successfully added."
      else
        render delivery_url, :status => :unprocessable_entity
      end
    end
  end
 
  def edit
    @delivery = Delivery.find_by_id(params[:delivery_id])
    if @delivery
      @delivery_detail = @delivery.delivery_details.find_by_id(params[:id])
    else
      redirect_to delivery_url(@delivery)
    end
  end

  def update
    @delivery = Delivery.find_by_id(params[:delivery_id])
    if @delivery
      @delivery_detail = @delivery.delivery_details.find_by_id(params[:id])
      if @delivery_detail.update_attributes(params[:delivery_detail])
        flash[:notice] = "Delivery detail successfully updated."
        redirect_to delivery_url(@delivery)
      else
        flash[:error] = "Unable to update delivery detail."
        render :action => 'edit'
      end
    else
      redirect_to delivery_url(@delivery)
    end
  end
end
