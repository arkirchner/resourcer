class IssuesController < ApplicationController
  before_action :render_forbidden, unless: :current_project_member
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
      redirect_to project_issue_url(current_project_member.project_id, issue),
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
          project_id: current_project_member.project_id,
          creator: current_project_member,
        ),
      )

    if issue.save
      redirect_to project_issue_url(current_project_member.project_id, issue),
                  notice: "New issue created."
    else
      render partial: "form",
             locals: { issue: issue },
             status: :unprocessable_entity
    end
  end

  def index
    @issues =
      Issue.with_project(current_project_member.project_id).includes(:project)
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
    if params[:id]
      @issue ||=
        Issue.with_project(current_project_member.project_id).find(params[:id])
    end
  end
end
