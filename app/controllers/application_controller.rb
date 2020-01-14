class ApplicationController < ActionController::Base
  before_action :redirect_unauthorized

  helper_method :current_project
  helper_method :current_member

  private

  def redirect_unauthorized
    redirect_to root_path unless current_member
  end

  def current_member
    @current_member ||= Member.find_by(id: session[:member_id])
  end

  def current_project
    return unless current_project_id

    Project.find_by(id: current_project_id)
  end

  def current_project_id
    params[:project_id]
  end
end
