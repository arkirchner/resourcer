class ProjectMemberIssueAssignment < ApplicationRecord
  belongs_to :project_member
  belongs_to :issue
end