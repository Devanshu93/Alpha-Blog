class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save      
      UserMailer.registration_confirmation(@user).deliver_now 
      flash[:success] = "Please confirm your email address to continue"
      redirect_to root_url
    else 
      flash[:error] = "Invalid, please try again"
      render 'new'
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      flash[:success] = "Welcome to Clash Royale Blog! Your email has been confirmed. Please sign in to continue."
      redirect_to login_url
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your account was updated succesfully"
      redirect_to articles_path
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5)
  end

  def show
    @user_articles = @user.articles.paginate(page: params[:page], per_page: 5)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "User and their articles have been deleted"
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user and !current_user.admin?
      flash[:danger] = "You can only edit your own account"
      redirect_to root_path
    end
  end

  def require_admin
    if logged_in? and !current_user.admin?
      flash[:danger] = "Only admins can perform that action"
      redirect_to root_path
    end
  end
end
