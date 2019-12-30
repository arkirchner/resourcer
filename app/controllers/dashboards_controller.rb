class DashboardsController < ApplicationController
  def show
    @projects = Project.all
    @issues = Issue.all
  end
end
