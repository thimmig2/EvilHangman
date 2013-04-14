class SessionsController < ApplicationController
  skip_before_filter :authorize

  def new
  end

  def create
    if user = User.authenticate(params[:username], params[:password])
      session[:user_id] = user.id
      redirect_to game_url
    else
      redirect_to login_url :notice => "Invalid username/password combination for #{params[:username]} "
    end
  end

  def destroy
=begin
    user = User.find(session[:user_id])

    if user.user_type == 1
      user.destroy
    end
=end

    session[:user_id] =  nil
    redirect_to login_url, :notice => "Logged Out"
  end
end
