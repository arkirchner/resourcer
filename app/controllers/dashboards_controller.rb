class DashboardsController < ApplicationController
  def show
    @projects = Project.with_member(current_member)
    @issues = Issue.all
  end
end
