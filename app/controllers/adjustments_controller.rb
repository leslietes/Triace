class AdjustmentsController < ApplicationController
  before_filter :login_required
  before_filter :get_products
  before_filter :get_customers
def index
  @adjustments = Adjustment.find(:all, :include => [:customer], :order => "adjustment_date DESC")
end

def show
  @adjustment = Adjustment.find_by_id(params[:id])
  if @adjustment
    @adjustment_details = AdjustmentDetail.find(:all, :conditions => ["adjustment_id = ?",  @adjustment.id], :include => [:product], :order => "products.name ASC") 
    @new_detail    = @adjustment.adjustment_details.new
  end
  respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "print.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Adjustment #{@adjustment.id}.pdf", :type => 'application/pdf')
        return
      }
    end
end

def new
  @adjustment = Adjustment.new
end

def create
    @adjustment = Adjustment.new(params[:adjustment])
    if @adjustment.save
      redirect_to adjustment_url(@adjustment), :notice => "Adjustment added successfully."
    else
      render :action => 'new', :status => :unprocessable_entity
    end
end

def edit
  @adjustment = Adjustment.find_by_id(params[:id])
end

def update
    @adjustment = Adjustment.find_by_id(params[:id])
    if @adjustment.update_attributes(params[:adjustment])
      redirect_to adjustments_url, :notice => "Adjustment successfully updated." 
    else
      render :action => 'edit'
    end
end

def destroy
end

end
