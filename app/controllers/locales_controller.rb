class LocalesController < ApplicationController
  def show
    loc = params[:locale].to_s
    session[:locale] = loc if I18n.available_locales.map(&:to_s).include?(loc)
    redirect_back_or_to root_path
  end
end
