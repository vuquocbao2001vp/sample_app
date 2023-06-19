class ApplicationController < ActionController::Base
  include Pagy::Backend
  include SessionsHelper
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  protect_from_forgery with: :exception

  private
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "flash.danger.login_required"
    redirect_to login_url
  end
end
