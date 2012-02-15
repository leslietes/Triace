class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required 
  before_filter :list_roles, :only => ["new","create","edit","update"]
  
  #TODO: Only admin can create and delete
  #TODO: Only admin can update certain fields
  
  #prawnto :prawn => { :top_margin => 75 }, :inline => false, :filename => "Payment Request"
  
  def index
    @users  = User.all
  end
  
  def new
    @user = User.new
  end
 
  def create
    #logout_keeping_session! - do not logout admin
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # Protects against session fixation attacks, causes request forgery
      # protection if visitor resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset session
      #self.current_user = @user # !! now logged in - only admin can add user
      #redirect_back_or_default('/', :notice => "Thanks for signing up!  We're sending you an email with your activation code.")
      redirect_to(users_url, :notice => "User added successfully.")
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def show
    @user = User.find_by_id(params[:id])
  end
  
  def edit
    @user = User.find_by_id(params[:id])
  end
  
  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to user_url(@user), :notice => "User successfully updated."
    else
      flash[:error] = "Unable to update user."
      render :action => 'edit'
    end
  end
  
  def destroy
    @user = User.find_by_id(params[:id])
    @user.destroy
    redirect_to(users_url, :notice => "User deleted.")
  end
  
  private
  
  def list_roles
    @roles = User::ROLES
  end
  
end
