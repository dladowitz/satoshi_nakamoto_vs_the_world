require "application_system_test_case"

class TrackersTest < ApplicationSystemTestCase
  setup do
    @tracker = trackers(:one)
  end

  test "visiting the index" do
    visit trackers_url
    assert_selector "h1", text: "Trackers"
  end

  test "creating a Tracker" do
    visit trackers_url
    click_on "New Tracker"

    fill_in "Asset one", with: @tracker.asset_one
    fill_in "Asset two", with: @tracker.asset_two
    fill_in "Name", with: @tracker.name
    fill_in "Start date", with: @tracker.start_date
    click_on "Create Tracker"

    assert_text "Tracker was successfully created"
    click_on "Back"
  end

  test "updating a Tracker" do
    visit trackers_url
    click_on "Edit", match: :first

    fill_in "Asset one", with: @tracker.asset_one
    fill_in "Asset two", with: @tracker.asset_two
    fill_in "Name", with: @tracker.name
    fill_in "Start date", with: @tracker.start_date
    click_on "Update Tracker"

    assert_text "Tracker was successfully updated"
    click_on "Back"
  end

  test "destroying a Tracker" do
    visit trackers_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Tracker was successfully destroyed"
  end
end
