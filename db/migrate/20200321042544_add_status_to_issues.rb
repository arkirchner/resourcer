class AddStatusToIssues < ActiveRecord::Migration[6.0]
  def change
    create_enum "issue_status", %w[open in_progess resolved closed]

    change_table :issues do |t|
      t.enum :status, as: "issue_status", null: false, default: "open"
    end

    change_table :history_issues do |t|
      t.enum :from_status, as: "issue_status"
      t.enum :to_status, as: "issue_status"
    end
  end
end
