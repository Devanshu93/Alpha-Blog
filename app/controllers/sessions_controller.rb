class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.email_confirmed
        session[:user_id] = user.id
        flash[:success] = "Login successful"
        redirect_to user_path(user)
      else
        flash.now[:error] = 'Please activate your account by following the 
        instructions in the account confirmation email you received to proceed'
        render 'new'
      end
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Logged out"
    redirect_to root_path
  end
end
