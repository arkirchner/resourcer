class MarkdownPreviewsController < ApplicationController
  layout false

  def create
    @markdown = params[:markdown]
  end
end
