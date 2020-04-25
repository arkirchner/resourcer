class AddSequentalIdToIssuesScopedByProjects < ActiveRecord::Migration[6.0]
  def up
    add_column :issues, :sequential_id, :integer

    execute <<~SQL
      UPDATE issues
      SET sequential_id = old_issues.next_sequential_id
      FROM (
        SELECT id, ROW_NUMBER()
        OVER(
          PARTITION BY project_id
          ORDER BY id
        ) AS next_sequential_id
        FROM issues
      ) old_issues
      WHERE issues.id = old_issues.id
    SQL

    change_column :issues, :sequential_id, :integer, null: false
    add_index :issues, %i[sequential_id project_id], unique: true
  end

  def down
    remove_column :issues, :sequential_id
  end
end
