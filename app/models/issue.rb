class Issue < ApplicationRecord
  extend ActsAsTree::TreeWalker
  acts_as_tree order: :subject
  belongs_to :project
  validates :subject, presence: true
  validate :cannot_have_itself_as_parent
  validate :parent_issue_must_have_same_project

  scope :with_project, ->(project) { where(project_id: project) }
  scope :without_issue, ->(issue) { where.not(id: issue) }


  def description_html
    renderer.render(ApplicationController.helpers.sanitize(description)).html_safe
  end

  private

  def parent_issue_must_have_same_project
    if parent && project_id != parent.project_id
      errors.add(:project_id, "must be the same as parent issue!")
    end
  end

  def cannot_have_itself_as_parent
    errors.add(:parent_id, "can't not be itself!") if self == parent
  end

  def renderer
    @renderer ||=
      Redcarpet::Markdown.new(
        Redcarpet::Render::HTML,
        autolink: true, tables: true,
      )
  end
end
