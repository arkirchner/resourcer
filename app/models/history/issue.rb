class History::Issue < ApplicationRecord
  CHANGES = %i[subject status due_at ancestry description assignee_id].freeze
  belongs_to :history
  belongs_to :issue, foreign_key: :item_id, class_name: "::Issue"
  belongs_to :from_parent, class_name: "::Issue", optional: true
  belongs_to :to_parent, class_name: "::Issue", optional: true
  belongs_to :from_assignee, class_name: "ProjectMember", optional: true
  belongs_to :to_assignee, class_name: "ProjectMember", optional: true

  scope :with_project,
        ->(project) { joins(:issue).merge(::Issue.where(project_id: project)) }

  def changes=(changes)
    changes.slice(*CHANGES).each do |key, values|
      from_value, to_value = values
      public_send("from_#{key}=", from_value) if from_value.present?
      public_send("to_#{key}=", to_value) if to_value.present?
    end
  end

  def from_ancestry=(ancestry)
    self.from_parent_id = ancestry.split("/").last
  end

  def to_ancestry=(ancestry)
    self.to_parent_id = ancestry.split("/").last
  end

  def status?
    from_status.present? || to_status.present?
  end

  def parent?
    from_parent_id.present? || to_parent_id.present?
  end

  def subject?
    from_subject.present? || to_subject.present?
  end

  def due_at?
    from_due_at.present? || to_due_at.present?
  end

  def description?
    from_description.present? || to_description.present?
  end

  def assignee?
    from_assignee_id.present? || to_assignee_id.present?
  end
end
