class History < ApplicationRecord
  belongs_to :member, optional: true
  belongs_to :associated_issue,
             class_name: "::Issue", foreign_key: :issue_id, optional: true

  has_one :issue, class_name: "History::Issue"
  has_one :project_member_issue_assignment,
          class_name: "History::ProjectMemberIssueAssignment"

  scope :related_to_member,
        lambda { |member|
          relation = left_joins(associated_issue: :project_member)
          relation.where(member_id: member).or(
            relation.merge(ProjectMember.where(member: member)),
          )
        }

  scope :with_project,
        lambda { |project|
          joins(:issue).merge(History::Issue.with_project(project))
        }

  def self.create_for_request(request_id)
    versions = PaperTrail::Version.where(request_id: request_id)

    return if versions.blank?

    transaction do
      issue_id =
        versions.detect { |v| v.item_type == "Issue" }&.item_id ||
          versions.select { |v| v.event == "create" }.map do |v|
            v.changeset[:issue_id]
          end.compact
            .map { |v| v[1] }.first ||
          versions.select { |v| v.event == "destroy" }.map do |v|
            v.changeset[:issue_id]
          end.compact
            .map { |v| v[0] }.first ||
          versions.select { |v| v.event == "update" }.map do |v|
            v.item&.issue_id
          end.compact
            .first

      first_version = versions.first
      event = versions.detect { |v| v.item_type == "Issue" }&.event || "update"

      history =
        create!(
          {
            id: request_id,
            issue_id: issue_id,
            member_id: first_version.whodunnit,
            changed_at: first_version.created_at,
            event: event,
          },
        )

      versions.each do |version|
        item_id = version.event == "destroy" ? nil : version.item_id

        "History::#{version.item_type}".constantize.create!(
          changes: version.changeset, history: history, item_id: item_id,
        )
      end
    end
  end
end
