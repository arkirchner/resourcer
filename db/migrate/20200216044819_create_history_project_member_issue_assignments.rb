class CreateHistoryProjectMemberIssueAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :history_project_member_issue_assignments do |t|
      t.bigint :item_id
      t.uuid :history_id, null: false
      t.bigint :from_project_member_id
      t.bigint :to_project_member_id

      t.timestamps
    end

    add_foreign_key :history_project_member_issue_assignments, :project_member_issue_assignments, column: :item_id, on_delete: :nullify
    add_foreign_key :history_project_member_issue_assignments, :project_members, column: :from_project_member_id
    add_foreign_key :history_project_member_issue_assignments, :project_members, column: :to_project_member_id
    add_foreign_key :history_project_member_issue_assignments, :histories
    add_index :history_project_member_issue_assignments, %i[id history_id], unique: true, name: :index_history_issue_assignments_on_id_and_history_id
    add_index :history_project_member_issue_assignments, :item_id
  end
end
