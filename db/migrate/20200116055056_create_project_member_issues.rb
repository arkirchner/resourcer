class CreateProjectMemberIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :project_member_issues do |t|
      t.belongs_to :project_member, null: false, foreign_key: true
      t.belongs_to :issue, null: false, foreign_key: true, index: false

      t.timestamps
    end

    add_index :project_member_issues, :issue_id, unique: true
  end
end
