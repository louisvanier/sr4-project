require "application_system_test_case"

class Templates::MatrixUsersTest < ApplicationSystemTestCase
  setup do
    @templates_matrix_user = templates_matrix_users(:one)
  end

  test "visiting the index" do
    visit templates_matrix_users_url
    assert_selector "h1", text: "Templates/Matrix Users"
  end

  test "creating a Matrix user" do
    visit templates_matrix_users_url
    click_on "New Templates/Matrix User"

    click_on "Create Matrix user"

    assert_text "Matrix user was successfully created"
    click_on "Back"
  end

  test "updating a Matrix user" do
    visit templates_matrix_users_url
    click_on "Edit", match: :first

    click_on "Update Matrix user"

    assert_text "Matrix user was successfully updated"
    click_on "Back"
  end

  test "destroying a Matrix user" do
    visit templates_matrix_users_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Matrix user was successfully destroyed"
  end
end
