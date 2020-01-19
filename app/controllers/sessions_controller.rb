class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :redirect_unauthorized, only: :create

  def create
    member = Member.find_or_create_from_auth_hash(auth_hash)
    session[:member_id] = member.id

    redirect_to dashboard_path, notice: "Hello #{member.name}"
  end

  def destroy
    message = "Goodbye #{current_member.name}."
    session[:member_id] = nil

    redirect_to root_path, notice: message
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end
end
