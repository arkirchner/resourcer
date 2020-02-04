class Invitation < ApplicationRecord
  belongs_to :project_member
  has_one :project, through: :project_member
  has_one :project_member_invitation

  scope :unused,
        lambda {
          left_outer_joins(:project_member_invitation).merge(
            ProjectMemberInvitation.where(id: nil),
          )
        }

  def self.verifier
    @verifier ||=
      ActiveSupport::MessageVerifier.new(
        Rails.application.secrets.secret_key_base,
      )
  end

  def self.accept(token, member)
    return false unless invitation_id = verifier.verified(token)

    invitation = unused.find(invitation_id)

    transaction do
      project_member =
        ProjectMember.create!(member: member, project: invitation.project)
      ProjectMemberInvitation.create!(
        project_member: project_member, invitation: invitation,
      )
    end
    invitation
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordNotFound
  end

  def token
    verifier.generate(id, expires_at: invalid_at)
  end

  def invalid_at
    created_at + 7.days
  end

  def invalid?
    Time.zone.now > invalid_at
  end

  private

  delegate :verifier, to: :class
end
