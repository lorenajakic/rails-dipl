class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def after_sign_out_path_for(_resource_or_scope)
    new_user_session_path
  end

  private

  def user_not_authorized
    redirect_back_or_to root_path, alert: t("pundit.not_authorized")
  end

  def pending_invitations_count
    return 0 unless user_signed_in?

    TripInvitation.pending_for(current_user).count
  end
  helper_method :pending_invitations_count

  def set_locale
    if controller_name == "locales" && params[:locale].present?
      loc = params[:locale].to_s
      session[:locale] = loc if I18n.available_locales.map(&:to_s).include?(loc)
    end

    requested = session[:locale].to_s
    if I18n.available_locales.map(&:to_s).include?(requested)
      I18n.locale = requested.to_sym
    else
      I18n.locale = I18n.default_locale
    end
  end

  def default_url_options
    return {} if I18n.locale == I18n.default_locale

    { locale: I18n.locale }
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name, :avatar ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :name, :avatar ])
  end
end
