class PasswordResetsController < ApplicationController
  before_action :find_user_by_email, :valid_user, :check_expiration, only: %i(edit update)
  before_action :check_empty_password, only: :update

  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email).downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "flash.info.reset_email_check"
      redirect_to root_url
    else
      flash.now[:danger] = t "flash.danger.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      log_in @user
      flash[:success] = t "flash.success.password_reseted"
      redirect_to @user
    else
      flash[:danger] = t "flash.danger.update_password_failed"
      render :edit
    end
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "flash.danger.expired_reset_password"
    redirect_to new_password_reset_url
  end
  private
  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user_by_email
    @user = User.find_by email: params[:email]
    return if @user

    flash[:warning] = t "flash.warning.email_not_found"
    redirect_to users_path
  end

  def valid_user
    return if @user.activated? && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "flash.danger.uncorrect_user"
    redirect_to root_url
  end

  def check_empty_password
    return unless params.dig(:user, :password).empty?

    @user.errors.add :password, t("validate.not_empty_required")
    render :edit
  end
end
