require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get get_user" do
    get :get_user
    assert_response :success
  end

  test "should get add_user" do
    get :add_user
    assert_response :success
  end

  test "should get delete_user" do
    get :delete_user
    assert_response :success
  end

end
