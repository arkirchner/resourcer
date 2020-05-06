module IssuesHelper
  def parent_issue_options(current_issue)
    Issue.parentable_issues(current_issue).pluck(:subject, :id)
  end

  def project_member_options(project)
    ProjectMember.joins(:member).select(:id, "members.name AS name").pluck(
      :name,
      :id,
    )
  end
end
