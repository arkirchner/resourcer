class ProjectGanttChartSerializer
  def initialize(project)
    @project = project
  end

  def to_h
    {
      constraints: [],
      activities: activities,
    }
  end

  def to_json
    to_h.to_json
  end

  private

  def issues
    project.issues
  end

  def activities
    issues.map do |issue|
      {
        id: issue.id.to_s,
        name: issue.subject,
        start: Time.now.beginning_of_day.to_i,
        end: (issue.due_at || 1.week.from_now).end_of_day.to_i,
        parent: nil,
      }
    end
  end

  attr_reader :project
end
