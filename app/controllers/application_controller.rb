class ApplicationController < ActionController::Base
  helper_method :current_project

  private

  def current_project
    return unless current_project_id

    Project.find_by(id: current_project_id)
  end

  def current_project_id
    params[:project_id]
  end
end
