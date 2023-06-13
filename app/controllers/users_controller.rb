class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t "flash.warning_user_not_found"
    redirect_to home_path
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "flash.success_user_created"
      redirect_to user_path @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password, :password_confirmation
  end
end
