class IssuesController < ApplicationController
  def new
    @issue = Issue.new
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def create
    @issue = Issue.new(issue_params)
    if @issue.save
      redirect_to issue_url(@issue),
        notice: "New issue created."
    else
      render :new
    end
  end

  private

  def issue_params
    params.require(:issue).permit(:subject, :due_at)
  end
end
