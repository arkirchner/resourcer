class IssuesController < ApplicationController
  def new
    @issue = Issue.new(project: current_project)
  end

  def show
    @issue = issue
  end

  def edit
    @issue = issue
  end

  def update
    if issue.update(issue_params)
      redirect_to issue_url(issue), notice: "Issue was updated."
    else
      render partial: "form", locals: { issue: issue }
    end
  end

  def create
    issue = Issue.new(issue_params.merge(project_id: params[:project_id]))

    if issue.save
      redirect_to issue_url(issue), notice: "New issue created."
    else
      render partial: "form", locals: { issue: issue }
    end
  end

  def index
    @issues = Issue.with_project(current_project_id).all
  end

  private

  def issue_params
    params.require(:issue).permit(
      :subject,
      :due_at,
      :parent_id,
      :description,
      :project_member_assignment_id,
    )
  end

  def issue
    id = params[:id]
    return if id.blank?

    Issue.includes(:project).find(id)
  end

  def current_project
    super || issue&.project
  end
end
