class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def show
    @project = Project.find(params[:id])
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to project_url(@project),
        notice: "New project was created."
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :key)
  end
end
