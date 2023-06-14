class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      redirect_to home_url
    else
      flash.now[:danger] = t "flash.danger_login_failed"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to home_url
  end
end
