class AddDescriptionToIssues < ActiveRecord::Migration[6.0]
  def change
    add_column :issues, :description, :text, null: false, default: ""
  end
end
