class DropHistoryProjectMemberIssueAssignments < ActiveRecord::Migration[6.0]
  def change
    drop_table :history_project_member_issue_assignments
  end
end
