class IssuesController < ApplicationController
  prepend_after_action :create_change_history, only: %i[create update]

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
      redirect_to project_issue_url(current_project, issue),
                  notice: "Issue was updated."
    else
      render partial: "form",
             locals: { issue: issue },
             status: :unprocessable_entity
    end
  end

  def create
    issue =
      Issue.new(
        issue_params.merge(
          project_id: params[:project_id], creator: current_project_member,
        ),
      )

    if issue.save
      redirect_to project_issue_url(current_project, issue),
                  notice: "New issue created."
    else
      render partial: "form",
             locals: { issue: issue },
             status: :unprocessable_entity
    end
  end

  def index
    @issues = Issue.with_project(params[:project_id]).all
  end

  private

  def create_change_history
    CreateHistoryJob.perform_later(request.request_id)
  end

  def issue_params
    params.require(:issue).permit(
      :subject,
      :due_at,
      :parent_id,
      :description,
      :assignee_id,
      :status,
    )
  end

  def issue
    @issue ||= Issue.includes(:project).find(params[:id]) if params[:id]
  end

  def current_project_member
    ProjectMember.find_by!(
      project_id: current_project.id, member_id: current_member.id,
    )
  end
end
