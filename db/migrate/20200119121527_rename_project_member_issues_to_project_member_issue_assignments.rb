class RenameProjectMemberIssuesToProjectMemberIssueAssignments < ActiveRecord::Migration[6.0]
  def change
    rename_table :project_member_issues, :project_member_issue_assignments
  end
end
