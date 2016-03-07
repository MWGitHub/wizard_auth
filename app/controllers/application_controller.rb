class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Expose these methods to the views
  helper_method :current_wizard, :signed_in?

  private
  def current_wizard
    @current_wizard ||= Wizard.find_by_session_token(session[:session_token])
  end

  def signed_in?
    !!current_wizard
  end

  def sign_in(wizard)
    @current_wizard = wizard
    session[:session_token] = wizard.reset_token!
  end

  def sign_out
    current_wizard.try(:reset_token!)
    session[:session_token] = nil
  end

  def require_signed_in!
    redirect_to new_session_url unless signed_in?
  end
end
