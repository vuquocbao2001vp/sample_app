class StaticPagesController < ApplicationController
  def home
    return unless logged_in?

    @micropost = current_user.microposts.build
    @pagy_feed_items, @feed_items = pagy current_user.feed
  end

  def help; end

  def about; end

  def contact; end
end
