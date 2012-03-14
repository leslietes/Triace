class PaymentsController < ApplicationController
  before_filter :login_required
  before_filter :get_customers

  def index
    @payments = Payment.all
  end

  def show
    @payment = Payment.find_by_id(params[:id], :include => [:customer])
    @payment_details = PaymentDetail.find(:all, 
                                          :include => [:customer, :order],
                                          :conditions => ["customer_id = ? and payment_id = ?", @payment.customer_id, @payment.id])   
   if @payment.not_fully_applied?
      @unpaid  = Order.find(:all, 
                            :include => [:customer], 
                            :conditions => ["customer_id = ? and paid = ? and delivered = true", @payment.customer_id, false])
    end    

  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(params[:payment])
    if @payment.save
      flash[:notice] = "Payment added successfully"
      redirect_to payment_url(@payment)
    else
      flash[:error] = "Error in adding payment"
      render :action => 'new'
    end
  end

  def edit
    @payment = Payment.find_by_id(params[:id])
  end

  def update
    @payment = Payment.find_by_id(params[:id])
    if @payment.update_attributes(params[:payment])
      flash[:notice] = "Payment updated successfully"
      redirect_to payments_url
    else
      flash[:error] = "Error in updating payment"
      render :action => 'edit'
    end
  end

  def destroy
    @payment = Payment.find_by_id(params[:id])
    if @payment.has_details?
      flash[:error] = "Unable to delete entry"
      return redirect_to :back
    end
    
    @payment.destroy
    
    respond_to do |format|
      format.html { redirect_to(payments_url) }
      format.xml  { head :ok }
    end
  end

 def apply_payment
    unless params[:id].blank? && params[:order_id].blank?
      payment = Payment.find_by_id(params[:id])
      order   = Order.find_by_id(params[:order_id])
      
      message = process_payment(payment,order)
      flash[:notice] = message
    end

    redirect_to payment_url(params[:id])
  end
  
  def cancel_payment
    unless params[:id].blank? && params[:order_id].blank?
      payment = Payment.find_by_id(params[:id])
      order   = Order.find_by_id(params[:order_id])
      
      process_cancellation(payment,order)
    end
    
    redirect_to payment_url(params[:id])
  end

  def payment_report
     @payments = []

    if params[:format] == 'pdf'
      @date_from    = session[:date_from]
      @date_to      = session[:date_to]
      @include_summary = session[:summary]
      @mode            = session[:mode]
    else
      @date_from    = params[:date_from] || Time.now.beginning_of_month.to_date
      @date_to      = params[:date_to]   || Time.now.end_of_month.to_date
      @include_summary = params[:summary] || "0"
      @mode            = params[:mode] || ''

      session[:date_from]   = @date_from
      session[:date_to]     = @date_to
      session[:summary]     = @include_summary
      session[:mode]        = @mode
    end

    sql = []

    if !session[:date_from].nil?
      sql << [" DATE(payments.payment_date) >= DATE('#{@date_from}') "]
    end

    if !session[:date_to].nil?
      sql << [" DATE(payments.payment_date) <= DATE('#{@date_to}') "]
    end

    if !session[:mode].blank?
      sql << [" mode = '#{@mode}' "]
    end


    sql = sql.join(" and ")

    @payments = Payment.find(:all, :conditions => [sql], :include => [{:payment_details => :order}, :customer], :order => "payments.payment_date ASC, payments.mode DESC, customers.name ASC")
    respond_to do |format|
      format.html
      format.pdf {
        html = render_to_string(:layout => false, :action => "payment_report.html.erb")
        kit  = PDFKit.new(html)
        kit.stylesheets << "#{Rails.root}/app/assets/stylesheets/application.css"
        send_data(kit.to_pdf, :filename => "Payment Report from #{@date_from} to #{@date_to}.pdf", :type => 'application/pdf')
        return
      }
    end

  end

  private

 def process_payment(payment,order)
    puts "PROCESS PAYMENT"
    
    payment_excess        = payment.excess    
    order_pending_payment = order.pending_payment
    
    puts "payment_excess: #{payment_excess}"
    puts "pending_payment: #{order_pending_payment}"
    
    # payment.total_amount < payment.amount_applied
    if payment.not_fully_applied?
      
      Payment.transaction do 
        # payment.amount >= order.amount
        if payment_excess >= order_pending_payment
          amount = order_pending_payment
        
        # payment amount < order amount
        elsif payment_excess < order_pending_payment
          amount = payment_excess
        end
      
        payment.apply(amount)
        order.pay_now(amount)
        
        PaymentDetail.create(:payment_id => payment.id,
                             :customer_id => payment.customer_id,
                             :order_id   => order.id,
                             :amount => amount)
        return "#{amount} applied"
      end
    else
      return "payment applied!"
    end
  end

  def process_cancellation(payment,order)
    detail = payment.payment_details.find_by_order_id(order.id)
    puts "@@@@@@@@@@@@ #{detail.inspect}"
    if detail
      puts "========="
      amount = detail.amount
      
      Payment.transaction do 
        payment.refund(amount)
        order.refund(amount)
        detail.remove
      end
    end
  end

end
