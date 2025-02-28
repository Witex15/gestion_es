require "application_system_test_case"

class SchoolClassesTest < ApplicationSystemTestCase
  setup do
    @school_class = school_classes(:one)
  end

  test "visiting the index" do
    visit school_classes_url
    assert_selector "h1", text: "School classes"
  end

  test "should create school class" do
    visit school_classes_url
    click_on "New school class"

    fill_in "Master", with: @school_class.master_id
    fill_in "Moment", with: @school_class.moment_id
    fill_in "Name", with: @school_class.name
    fill_in "Room", with: @school_class.room_id
    fill_in "Sector", with: @school_class.sector_id
    fill_in "Uid", with: @school_class.uid
    click_on "Create School class"

    assert_text "School class was successfully created"
    click_on "Back"
  end

  test "should update School class" do
    visit school_class_url(@school_class)
    click_on "Edit this school class", match: :first

    fill_in "Master", with: @school_class.master_id
    fill_in "Moment", with: @school_class.moment_id
    fill_in "Name", with: @school_class.name
    fill_in "Room", with: @school_class.room_id
    fill_in "Sector", with: @school_class.sector_id
    fill_in "Uid", with: @school_class.uid
    click_on "Update School class"

    assert_text "School class was successfully updated"
    click_on "Back"
  end

  test "should destroy School class" do
    visit school_class_url(@school_class)
    click_on "Destroy this school class", match: :first

    assert_text "School class was successfully destroyed"
  end
end
