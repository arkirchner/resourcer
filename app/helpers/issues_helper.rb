module IssuesHelper
  def parent_issue_options(current_issue)
    issues = current_project.issues.without_issue(current_issue.self_and_descendants)

    issues.map do |issue|
      [issue.subject, issue.id]
    end
  end

  def project_member_options(project)
    project.project_members.map do |project_member|
      [project_member.member.name, project_member.id]
    end
  end
end
