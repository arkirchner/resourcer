module IssuesHelper
  def parent_issue_options(current_issue)
    current_project.issues.without_issue(current_issue).map do |issue|
      [issue.subject, issue.id]
    end
  end
end
