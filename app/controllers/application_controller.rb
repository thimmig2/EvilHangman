class ApplicationController < ActionController::Base
  before_filter :authorize
  protect_from_forgery

  private


    def current_session
      Session.find(session[:session_id])
    rescue ActiveRecord::RecordNotFound
      userSession = Session.create
      session[:session_id] = userSession.id
      userSession
    end

  protected
    def authorize
      unless User.find_by_id(session[:user_id])
        redirect_to login_url, :notice => "Please log in"
      end
    end

end
