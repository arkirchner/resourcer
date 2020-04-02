class ChangeCreatorIdToConnectToProjectMembers < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :issues, :members, column: :creator_id
    add_foreign_key :issues,
                    :project_members,
                    column: :creator_id
    add_column :history_issues, :from_creator_id, :bigint
    add_column :history_issues, :to_creator_id, :bigint
    add_foreign_key :history_issues,
                    :project_members,
                    column: :from_creator_id
    add_foreign_key :history_issues,
                    :project_members,
                    column: :to_creator_id
  end
end
