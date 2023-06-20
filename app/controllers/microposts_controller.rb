class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  before_action :prepare_create_micropost, only: :create

  def create
    if @micropost.save
      flash[:success] = t "flash.success.micropost_created"
      redirect_to root_url
    else
      @pagy_feed_items, @feed_items = pagy current_user.feed
      flash[:danger] = t "flash.danger.micropost_created_unsuccessful"
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy!
    flash[:success] = t "flash.success.micropost_deleted"
  rescue ActiveRecord::RecordNotDestroyed
    flash[:danger] = t "flash.danger.micropost_deleted_unsuccessful"
  ensure
    redirect_to request.referer || root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t "flash.danger.uncorrect_user"
    redirect_to root_url
  end

  def prepare_create_micropost
    @micropost = current_user.microposts.build micropost_params
    @micropost.image.attach params.dig(:micropost, :image)
  end
end
