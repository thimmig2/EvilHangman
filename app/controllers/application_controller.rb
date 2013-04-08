class ApplicationController < ActionController::Base
  protect_from_forgery

  private
    def current_session
      Session.find(session[:session_id])
    rescue ActiveRecord::RecordNotFound
      userSession = Session.create
      session[:session_id] = userSession.id
      userSession
    end

end
