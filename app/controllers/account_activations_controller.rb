class AccountActivationsController < ApplicationController
  before_action :find_user_by_email, only: :edit

  def edit
    if !@user.activated? && @user.authenticated?(:activation, params[:id])
      @user.activate
      log_in @user
      flash[:success] = t "flash.success.activated_account"
      redirect_to @user
    else
      flash[:danger] = t "flash.danger.invalid_activation_link"
      redirect_to root_url
    end
  end

  private

  def find_user_by_email
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t "flash.warning.email_not_found"
    redirect_to users_path
  end
end
