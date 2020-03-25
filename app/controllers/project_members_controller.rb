class ProjectMembersController < ApplicationController
  def index
    @project_members = current_project.project_members.includes(:member)
    @invitations = current_project.invitations.unused
  end
end
