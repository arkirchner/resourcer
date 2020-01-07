class ApplicationController < ActionController::Base
  before_action :redirect_unauthorized

  helper_method :current_project
  helper_method :current_user

  private

  def redirect_unauthorized
    redirect_to root_path unless current_user
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_project
    return unless current_project_id

    Project.find_by(id: current_project_id)
  end

  def current_project_id
    params[:project_id]
  end
end
