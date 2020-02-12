class CreateHistoryIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :history_issues do |t|
      t.bigint :item_id
      t.uuid :history_id, null: false
      t.string :from_subject, null: false, default: ""
      t.string :to_subject, null: false, default: ""
      t.date :from_due_at
      t.date :to_due_at
      t.bigint :from_parent_id
      t.bigint :to_parent_id
      t.text :from_description, null: false, default: ""
      t.text :to_description, null: false, default: ""

      t.timestamps
    end

    add_foreign_key :history_issues, :issues, column: :item_id, on_delete: :nullify
    add_foreign_key :history_issues, :issues, column: :from_parent_id
    add_foreign_key :history_issues, :issues, column: :to_parent_id
    add_foreign_key :history_issues, :histories
    add_index :history_issues, %i[id history_id], unique: true
    add_index :history_issues, :item_id
  end
end
