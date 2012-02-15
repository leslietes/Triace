class AdjustmentDetailsController < ApplicationController
  before_filter :get_products
   def create
    adjustment = Adjustment.find_by_id(params[:adjustment_id])
    if adjustment
      @adjustment_detail = adjustment.adjustment_details.create(
		:quantity_in  => params[:quantity_in],
		:quantity_out => params[:quantity_out],
		:product_id   => params[:product_id],
  		:unit 	      => params[:unit],
		:unit_price   => params[:distributors_price]
	)
      if @adjustment_detail.save
        redirect_to adjustment_url(adjustment), :notice => "Adjustment successfully added."
      else
        render adjustment_url, :status => :unprocessable_entity
      end
    end
  end

  def edit
    @adjustment = Adjustment.find_by_id(params[:adjustment_id])
    if @adjustment
      @adjustment_detail = @adjustment.adjustment_details.find_by_id(params[:id])
    else
      redirect_to adjustment_url(@adjustment)
    end
  end

  def update
    adjustment = Adjustment.find_by_id(params[:adjustment_id])
    if adjustment
      @adjustment_detail = adjustment.adjustment_details.find_by_id(params[:id])
      if @adjustment_detail.update_attributes(params[:adjustment_detail])
        flash[:notice] = "Adjustment detail successfully updated."
        redirect_to adjustment_url(adjustment)
      else
        flash[:error] = "Unable to update adjustment detail."
        render :action => 'edit'
      end
    else
      redirect_to adjustment_url(adjustment)
    end
  end
end
