module InvitationsHelper
  def new_invitation?(invitation)
    params[:new_invitation_id] == invitation.id.to_s
  end

  def can_see_invitations?(project_members, member)
    project_members.find { |project_member| project_member.member_id == member.id }.owner
  end
end
