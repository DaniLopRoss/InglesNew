require "application_system_test_case"

describe "Users", :system do
  let(:user) { users(:one) }

  it "visiting the index" do
    visit users_url
    assert_selector "h1", text: "Users"
  end

  it "creating a User" do
    visit users_url
    click_on "New User"

    click_on "Create User"

    assert_text "User was successfully created"
    click_on "Back"
  end

  it "updating a User" do
    visit users_url
    click_on "Edit", match: :first

    click_on "Update User"

    assert_text "User was successfully updated"
    click_on "Back"
  end

  it "destroying a User" do
    visit users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "User was successfully destroyed"
  end
end
