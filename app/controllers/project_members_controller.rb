class ProjectMembersController < ApplicationController
  before_action :render_forbidden, unless: :current_project

  def index
    @project_members = current_project.project_members.includes(:member)
    @invitations = current_project.invitations.unused
  end
end
