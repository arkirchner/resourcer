class RemoveParentIdFromIssues < ActiveRecord::Migration[6.0]
  def change

    remove_column :issues, :parent_id, :bigint
  end
end
