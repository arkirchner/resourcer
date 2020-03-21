class CreateIssueCounts < ActiveRecord::Migration[6.0]
  def change
    create_view :issue_counts
  end
end
