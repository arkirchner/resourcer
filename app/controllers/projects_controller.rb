class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    project = Project.new(project_params)
    if project.save
      redirect_to project_url(project),
                  notice: "New project was created."
    else
      render partial: "form", locals: { project: project }
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :key)
  end

  def current_project_id
    params[:id]
  end
end
