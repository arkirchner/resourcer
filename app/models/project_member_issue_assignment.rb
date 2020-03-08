class ProjectMemberIssueAssignment < ApplicationRecord
  has_paper_trail
  belongs_to :project_member
  belongs_to :issue
end
