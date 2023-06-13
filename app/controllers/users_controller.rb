class UsersController < ApplicationController
  include Pagy::Backend

  before_action :logged_in_user, except: %i(new show create)
  before_action :admin_user, only: :destroy
  before_action :find_user_by_id, only: %i(show update edit destroy)
  before_action :correct_user, only: %i(edit update)
  def index
    @pagy, @users = pagy User.order_by_name
  end

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "flash.success_user_created"
      redirect_to user_path @user
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "flash.success_user_updated"
      redirect_to user_path @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy!
    flash[:success] = t "flash.success_user_deleted"
  rescue ActiveRecord::RecordNotDestroyed
    flash[:danger] = t "flash.danger_user_deleted_unsuccessfully"
  ensure
    redirect_to users_url
  end

  private

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.warning_user_not_found"
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("flash.danger_login_required")
    redirect_to login_url
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("flash.danger_uncorrect_user")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t("flash.danger_admin_required")
    redirect_to root_url
  end
end
