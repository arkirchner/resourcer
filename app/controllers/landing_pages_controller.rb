class LandingPagesController < ApplicationController
  skip_before_action :redirect_unauthorized

  def show
    redirect_to dashboard_url if current_member
  end
end
