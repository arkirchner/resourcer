class DashboardsController < ApplicationController
  private

  def current_member
    @current_member =
      Member.includes(:assigned_issues, :projects).find_by(
        id: session[:member_id],
      )
  end
end
