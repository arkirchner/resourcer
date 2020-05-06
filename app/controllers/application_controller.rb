class ApplicationController < ActionController::Base
  before_action :raven_context
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
    return current_project_member.member if current_project_member

    @current_member ||= Member.find(current_member_id)
  end

  def current_project_member
    return unless current_member_id && current_project_id

    @current_project_member ||=
      ProjectMember.eager_load(:member, :project).find_by(
        project_id: current_project_id, member_id: current_member_id,
      )
  end

  def current_project
    current_project_member&.project
  end

  def info_for_paper_trail
    { whodunnit: current_member_id, request_id: request.request_id }
  end

  def raven_context
    Raven.user_context(id: current_member_id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
