class PagesController < ApplicationController
  skip_before_action :redirect_unauthorized, only: :show
  include HighVoltage::StaticPage
end
