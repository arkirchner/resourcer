module IssuesHelper
  def parent_issue_options(issue)
    current_project.issues.without_issue(issue).collect do |issue|
      [issue.subject, issue.id]
    end
  end
end
