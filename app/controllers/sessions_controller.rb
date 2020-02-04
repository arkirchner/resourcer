class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :redirect_unauthorized, only: %i[create failure]

  def create
    member = Member.find_or_create_from_auth_hash(auth_hash)
    session[:member_id] = member.id
    flash[:notice] = "Hello #{member.name}"

    if invitation_token
      redirect_to join_project_url(invitation_token)
    else
      redirect_to dashboard_url
    end
  end

  def destroy
    message = "Goodbye #{current_member.name}."
    session[:member_id] = nil

    redirect_to root_path, notice: message
  end

  def failure
    redirect_to root_url, alert: params["message"]
  end

  private

  def auth_hash
    request.env["omniauth.auth"]
  end

  def invitation_token
    session[:invitation_token]
  end
end
