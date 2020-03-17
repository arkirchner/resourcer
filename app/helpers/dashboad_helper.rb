module DashboadHelper
  def my_issues_selection(my_issues_params, select_params)
    tag.div do
      my_issues_params.merge(select_params).each do |key, value|
        concat hidden_field_tag("my_issue[#{key}]", value)
      end
    end
  end
end
