require "test_helper"

class ProjectGanttChartSerializerTest < ActiveSupport::TestCase
  SCHEMA =
    schema = {
      "type" => "object",
      "required" => %w[constraints activities],
      "properties" => {
        "constraints" => {
          "type" => "array",
          "items" => {
            "type" => "object",
            "required" => %w[from to],
            "properties" => {
              "from" => { "type" => "string" }, "to" => { "type" => "string" }
            },
          },
        },
        "activities" => {
          "type" => "array",
          "items" => {
            "type" => "object",
            "required" => %w[id name start end parent],
            "properties" => {
              "id" => { "type" => "string" },
              "name" => { "type" => "string" },
              "start" => { "type" => "number" },
              "end" => { "type" => "number" },
              "parent" => { "type" => %w[string null] },
            },
          },
        },
      },
    }.freeze

  def project
    @project ||= FactoryBot.create(:project).tap do |project|
      issue =
        FactoryBot.create(
          :issue,
          subject: "Create a landing page.", project: project,
        )
      FactoryBot.create(
        :issue,
        subject: "Create a getting started guide.",
        project: project,
        parent: issue,
      )
    end
  end

  def json
    ProjectGanttChartSerializer.new(project).to_json
  end

  test "serialixes a project correctly" do
    assert JSON::Validator.validate(schema, json),
           "JSON output dose not match the Schema."
  end

  test "Issue are serialized." do
    assert_match "Create a landing page.",
                 json,
                 "JSON dose not include first issue"
    assert_match "Create a getting started guide.",
                 json,
                 "JSON dose not include first issue"
  end

  test "includes constraint for activety arrow" do
    child_issue = project.issues.last
    constraint = "{\"from\":\"#{child_issue.parent_id}\",\"to\":\"#{child_issue.id}\",\"type\":1}"

    assert_match constraint,
                 json,
                 "constraint is not included"
  end
end