class DashboardsController < ApplicationController
  def show
    @histories =
      History.related_to_member(@current_member).order(changed_at: :desc)
    @issues = if created_by_member?
                current_member.created_issues
              else
                current_member.assigned_issues
              end
    @my_issues_params = my_issues_params
  end

  private

  def my_issues_params
    return { assigned: "true" } if params[:my_issue].blank?

    params.require(:my_issue).permit(:assigned, :created, :all, :four_day, :today, :overdue)
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
