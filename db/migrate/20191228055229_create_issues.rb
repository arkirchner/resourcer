class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :subject, null: false
      t.date :due_at

      t.timestamps
    end
  end
end
