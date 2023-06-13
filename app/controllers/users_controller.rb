class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new show create)
  before_action :admin_user, only: :destroy
  before_action :find_user_by_id, only: %i(show update edit destroy following followers)
  before_action :correct_user, only: %i(edit update)
  def index
    @pagy, @users = pagy User.order_by_name
  end

  def new
    @user = User.new
  end

  def show
    @pagy_micropost, @microposts = pagy @user.microposts.newest
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "flash.info.activate_email_check"
      redirect_to login_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "flash.success.user_updated"
      redirect_to user_path @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy!
    flash[:success] = t "flash.success.user_deleted"
  rescue ActiveRecord::RecordNotDestroyed
    flash[:danger] = t "flash.danger.user_deleted_unsuccessfully"
  ensure
    redirect_to users_url
  end

  def following
    @title = t "users.show_follow.following_title"
    @pagy_users, @users = pagy @user.following.order_by_name
    render :show_follow
  end

  def followers
    @title = t "users.show_follow.followers_title"
    @pagy_users, @users = pagy @user.followers.order_by_name
    render :show_follow
  end
  private

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.warning.user_not_found"
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end

  def correct_user
    return if current_user?(@user)

    flash[:danger] = t("flash.danger.uncorrect_user")
    redirect_to root_url
  end

  def admin_user
    return if current_user.admin?

    flash[:danger] = t("flash.danger.admin_required")
    redirect_to root_url
  end
end
