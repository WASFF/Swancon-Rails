require 'test_helper'

class LaunchMembersControllerTest < ActionController::TestCase
  setup do
    @launch_member = launch_members(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:launch_members)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create launch_member" do
    assert_difference('LaunchMember.count') do
      post :create, :launch_member => @launch_member.attributes
    end

    assert_redirected_to launch_member_path(assigns(:launch_member))
  end

  test "should show launch_member" do
    get :show, :id => @launch_member.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @launch_member.to_param
    assert_response :success
  end

  test "should update launch_member" do
    put :update, :id => @launch_member.to_param, :launch_member => @launch_member.attributes
    assert_redirected_to launch_member_path(assigns(:launch_member))
  end

  test "should destroy launch_member" do
    assert_difference('LaunchMember.count', -1) do
      delete :destroy, :id => @launch_member.to_param
    end

    assert_redirected_to launch_members_path
  end
end
