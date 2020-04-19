class InvitationsController < ApplicationController
  before_action :render_forbidden, if: :unauthorized?
  layout false

  def new
    @invitation = Invitation.new(project_member: current_project_member)
  end

  def create
    @invitation =
      Invitation.new(
        invitation_params.merge(project_member: current_project_member),
      )

    if @invitation.save
      redirect_to project_members_path(
                    current_project_member.project_id,
                    new_invitation_id: @invitation.id,
                  )
    else
      render :show, status: :unprocessable_entity
    end
  end

  def show
    @invitation =
      Invitation.where(project_member: current_project_member).find(params[:id])
  end

  private

  def unauthorized?
    !current_project_member&.owner
  end

  def invitation_params
    params.require(:invitation).permit(:note)
  end
end
