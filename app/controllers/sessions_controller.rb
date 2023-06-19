class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params.dig(:session, :email).downcase
    authenticate_user user
  end

  def destroy
    log_out if logged_in?
    redirect_to home_url
  end

  def authenticate_user user
    if user&.authenticate params.dig(:session, :password)
      if user.activated?
        log_in user
        params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "flash.warning.not_activated_account"
        redirect_to root_url
      end
    else
      flash.now[:danger] = t "flash.danger.login_failed"
      render :new
    end
  end
end
