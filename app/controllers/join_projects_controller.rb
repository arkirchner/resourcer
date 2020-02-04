class JoinProjectsController < ApplicationController
  skip_before_action :redirect_unauthorized, only: :show

  def show
    if current_member
      session[:invitation_token] = nil
      invitation = Invitation.accept(params[:id], current_member)

      if invitation
        project = invitation.project
        flash[:notice] = "You have joined \"#{project.key}: #{project.name}\""
      else
        flash[:alert] =
          "Your project inviation is expired. Please contact the project " \
          "owner to recieve a new inviation url."
      end

      redirect_to dashboard_url
    else
      session[:invitation_token] = params[:id]
      redirect_to root_url
    end
  end
end
