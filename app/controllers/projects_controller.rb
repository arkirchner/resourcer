class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    project = Project.new(project_params)
    if project.save_with_inital_member(current_member)
      redirect_to project_url(project), notice: "New project was created."
    else
      render partial: "form",
             locals: { project: project },
             status: :unprocessable_entity
    end
  end

  private

  def project_id
    params[:id]
  end

  def current_project
    Project.find(project_id) if project_id
  end

  def project_params
    params.require(:project).permit(:name, :key)
  end
end
