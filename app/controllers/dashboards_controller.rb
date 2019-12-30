class DashboardsController < ApplicationController
  def show
    @projects = Project.all
  end
end
