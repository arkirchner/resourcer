class History::Issue < ApplicationRecord
  CHANGES = %i[subject due_at parent_id description].freeze
  belongs_to :history
  belongs_to :issue, foreign_key: :item_id, class_name: "::Issue"
  belongs_to :from_parent, class_name: "::Issue", optional: true
  belongs_to :to_parent, class_name: "::Issue", optional: true

  scope :with_project,
        ->(project) { joins(:issue).merge(::Issue.where(project_id: project)) }

  def changes=(changes)
    changes.slice(*CHANGES).each do |key, values|
      from_value, to_value = values
      write_attribute("from_#{key}", from_value) if from_value.present?
      write_attribute("to_#{key}", to_value) if to_value.present?
    end
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
end
