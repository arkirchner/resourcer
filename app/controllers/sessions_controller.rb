class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :redirect_unauthorized, only: :create

  def create
    user = User.find_or_create_from_auth_hash(auth_hash)
    session[:user_id] = user.id

    redirect_to dashboard_path, notice: "Hello #{user.name}"
  end

  def destroy
    message = "Goodbye #{current_user.name}."
    session[:user_id] = nil

    redirect_to root_path, notice: message
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
