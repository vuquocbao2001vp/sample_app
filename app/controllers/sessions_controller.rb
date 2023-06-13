class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    authenticate_user user
  end

  def destroy
    log_out if logged_in?
    redirect_to home_url
  end

  private
  def authenticate_user user
    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == "1" ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = t "flash.danger_login_failed"
      render :new
    end
  end
end
