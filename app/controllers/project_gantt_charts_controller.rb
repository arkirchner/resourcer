class ProjectGanttChartsController < ApplicationController
  def show
    @gantt_chart_json = ProjectGanttChartSerializer.new(current_project).to_json
  end
end
