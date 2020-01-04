class AddParentIdToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :parent_id, :bigint, index: true
    add_foreign_key :issues, :issues, column: :parent_id
  end
end
