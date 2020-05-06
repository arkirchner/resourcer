class DashboardsController < ApplicationController
  def show
    @histories =
      History.related_to_member(current_member).order(changed_at: :desc).limit(
        20,
      )
    @issues = issues
    @my_issues_params = my_issues_params
  end

  private

  def issues
    if my_issues_params[:created] == "true"
      current_member.created_issues.incomplete
    elsif my_issues_params[:assigned] == "true"
      current_member.assigned_issues.incomplete
    end.then do |relation|
      if my_issues_params[:all] == "true"
        relation
      elsif my_issues_params[:four_day] == "true"
        relation.where(due_at: Date.today..4.days.from_now)
      elsif my_issues_params[:today] == "true"
        relation.where(due_at: Date.today)
      elsif my_issues_params[:overdue] == "true"
        relation.where(Issue.arel_table[:due_at].lt(Date.today))
      end
    end.joins(:project).select("issues.*, projects.key AS project_key")
  end

  def my_issues_params
    if params[:my_issue].blank?
      return(
        {
          assigned: "true",
          created: "false",
          all: "true",
          four_day: "false",
          today: "false",
          overdue: "false",
        }
      )
    end

    params.require(:my_issue).permit(
      :assigned,
      :created,
      :all,
      :four_day,
      :today,
      :overdue,
    )
  end

  def created_by_member?
    params[:issues_by_member].present?
  end
end
