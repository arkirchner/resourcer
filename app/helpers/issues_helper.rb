module IssuesHelper
  def parent_issue_options(current_issue)
    Issue.parentable_issues(current_issue).map do |issue|
      [issue.subject, issue.id]
    end
  end

  def project_member_options(project)
    project.project_members.map do |project_member|
      [project_member.member.name, project_member.id]
    end
  end
end
