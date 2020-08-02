class ProjectsController < ApplicationController
  def new
    @project = Project.new
  end

  def show
    @histories =
      current_project.histories.order(changed_at: :desc).limit(20)
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

  def current_project_id
    params[:id]
  end

  def project_params
    params.require(:project).permit(:name, :key)
  end
end
