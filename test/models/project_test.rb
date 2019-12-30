require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "should not save a project without subject" do
    project = FactoryBot.build :project, name: nil
    assert_not project.save, "Saved the project without a name"
  end

  test "should not save a project with key with incorrect length" do
    short_project = FactoryBot.build :project, key: "AA"
    assert_not short_project.save, "Saved the project without 2 letter key"

    long_project = FactoryBot.build :project, key: "AAAA"
    assert_not long_project.save, "Saved the project without 4 letter key"
  end

  test "should only allow letters and numbers" do
    whitespace = FactoryBot.build :project, key: "A A"
    assert_not whitespace.save, "Saved the project with a whitespace"

    special_character = FactoryBot.build :project, key: "AA+"
    assert_not special_character.save, "Saved the project with a special character"
  end

  test "key with down case values are upcased" do
    project = FactoryBot.build :project, key: "abc"
    project.valid?

    assert_equal project.key, "ABC", "Key values have not been upcased"
  end

  test "key must be unique" do
    FactoryBot.create :project, key: "ABC"
    project = FactoryBot.build :project, key: "ABC"
    assert_not project.save, "Saved the project with duplicate key"
  end
end
