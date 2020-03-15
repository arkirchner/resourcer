class DashboardsController < ApplicationController
  def show
    @histories =
      History.related_to_member(@current_member).order(changed_at: :desc)
    @issues = if created_by_member?
                current_member.created_issues
              else
                current_member.assigned_issues
              end
  end

  private

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
