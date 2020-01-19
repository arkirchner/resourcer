class ProjectMembersController < ApplicationController
  def index
    @project_members = current_project.project_members
  end
end
