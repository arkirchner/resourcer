class DashboardsController < ApplicationController
  def show
    @histories =
      History.related_to_member(@current_member).order(changed_at: :desc)
  end

  private

  def current_member
    @current_member =
      Member.includes(:assigned_issues, :projects).find_by(
        id: session[:member_id],
      )
  end
end
