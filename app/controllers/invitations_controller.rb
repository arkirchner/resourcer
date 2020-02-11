class InvitationsController < ApplicationController
  layout false

  before_action :authorize_project_owner

  def new
    @invitation = Invitation.new(project_member: project_member)
  end

  def create
    @invitation =
      Invitation.new(invitation_params.merge(project_member: project_member))

    if @invitation.save
      redirect_to project_members_path(
                    project_member.project,
                    new_invitation_id: @invitation.id,
                  )
    else
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @invitation =
      Invitation.where(project_member: project_member).find(params[:id])
  end

  private

  def authorize_project_owner
    unless project_member.owner?
      render plain: "unauthorized", status: :unauthorized
    end
  end

  def invitation_params
    params.require(:invitation).permit(:note)
  end

  def project_member
    @project_member ||=
      ProjectMember.find_by!(project: current_project, member: current_member)
  end
end
