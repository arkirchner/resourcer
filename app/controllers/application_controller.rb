class ApplicationController < ActionController::Base
  before_action :redirect_unauthorized

  helper_method :current_project
  helper_method :current_member

  private

  def render_forbidden
    render plain: "Forbidden", status: :forbidden
  end

  def redirect_unauthorized
    redirect_to root_path unless current_member
  end

  def current_project_member?
    current_project_member.present?
  end

  def current_member_id
    session[:member_id]
  end

  def current_project_id
    params[:project_id]
  end

  def current_member
    return unless current_member_id

    @current_member ||= Member.find(current_member_id)
  end

  def current_project_member
    return unless current_member_id && current_project_id

    ProjectMember.find_by(
      project_id: current_project_id, member_id: current_member_id,
    )
  end

  def current_project
    return unless current_member_id && current_project_id

    Project.with_member(current_member_id).find_by(id: current_project_id)
  end

  def info_for_paper_trail
    { whodunnit: current_member_id, request_id: request.request_id }
  end
end
