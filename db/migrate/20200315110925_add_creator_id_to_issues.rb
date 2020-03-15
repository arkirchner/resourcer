class AddCreatorIdToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :creator_id, :bigint
    add_index :issues, :creator_id
    add_foreign_key :issues, :members, column: :creator_id
  end
end
