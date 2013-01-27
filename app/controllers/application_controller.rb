class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :set_locale, :flash_to_gflash, :set_auditor
  
  
  protected
    def flash_to_gflash
      [:notice, :error, :alert].each do |flevel|
        if f = flash[flevel]
          flevel = :error if flevel == :alert
          gflash flevel => f
        end
      end
    end
  
    def set_locale
      available = I18n.available_locales
      
      preferred = request.preferred_language_from(available) || I18n.default_locale
      compatible = request.compatible_language_from(available)
      
      if (l = params[:locale]).present? && available.include?(l.to_sym)
        session[:locale] = l.to_sym
      end
      
      I18n.locale = session[:locale] || current_user.try(:locale) || preferred || compatible
      
      current_user.try :update_attribute, :locale, I18n.locale.to_s
    end
    
    def set_auditor
      Auditor::User.current_user = current_user
    end
    
    def after_sign_in_path_for(resource)
      session[:user_return_to] || events_path
    end
    
    def after_sign_out_path_for(resource)
      new_session_path(resource)
    end
end
