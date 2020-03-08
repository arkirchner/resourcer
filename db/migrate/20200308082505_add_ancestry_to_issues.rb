class AddAncestryToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :ancestry, :string
    add_index :issues, :ancestry
  end
end
