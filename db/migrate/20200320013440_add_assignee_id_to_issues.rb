class AddAssigneeIdToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :assignee_id, :bigint
    add_foreign_key :issues,
                    :project_members,
                    column: :assignee_id
    add_column :history_issues, :from_assignee_id, :bigint
    add_column :history_issues, :to_assignee_id, :bigint
    add_foreign_key :history_issues,
                    :project_members,
                    column: :from_assignee_id
    add_foreign_key :history_issues,
                    :project_members,
                    column: :to_assignee_id
  end
end
