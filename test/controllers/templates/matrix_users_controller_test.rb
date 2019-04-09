require 'test_helper'

class Templates::MatrixUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @templates_matrix_user = templates_matrix_users(:one)
  end

  test "should get index" do
    get templates_matrix_users_url
    assert_response :success
  end

  test "should get new" do
    get new_templates_matrix_user_url
    assert_response :success
  end

  test "should create templates_matrix_user" do
    assert_difference('Templates::MatrixUser.count') do
      post templates_matrix_users_url, params: { templates_matrix_user: {  } }
    end

    assert_redirected_to templates_matrix_user_url(Templates::MatrixUser.last)
  end

  test "should show templates_matrix_user" do
    get templates_matrix_user_url(@templates_matrix_user)
    assert_response :success
  end

  test "should get edit" do
    get edit_templates_matrix_user_url(@templates_matrix_user)
    assert_response :success
  end

  test "should update templates_matrix_user" do
    patch templates_matrix_user_url(@templates_matrix_user), params: { templates_matrix_user: {  } }
    assert_redirected_to templates_matrix_user_url(@templates_matrix_user)
  end

  test "should destroy templates_matrix_user" do
    assert_difference('Templates::MatrixUser.count', -1) do
      delete templates_matrix_user_url(@templates_matrix_user)
    end

    assert_redirected_to templates_matrix_users_url
  end
end
