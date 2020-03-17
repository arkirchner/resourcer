class DashboardsController < ApplicationController
  def show
    @histories =
      History.related_to_member(@current_member).order(changed_at: :desc)
    @issues =
      if my_issues_params[:created] == "true"
        current_member.created_issues
      elsif my_issues_params[:assigned] == "true"
        current_member.assigned_issues
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
      end

    @my_issues_params = my_issues_params
  end

  private

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

  def current_member
    @current_member ||=
      Member.includes(:assigned_issues, :projects).find_by(
        id: session[:member_id],
      )
  end
end
