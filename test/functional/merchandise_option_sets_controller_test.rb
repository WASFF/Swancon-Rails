require 'test_helper'

class MerchandiseOptionSetsControllerTest < ActionController::TestCase
  setup do
    @merchandise_option_set = merchandise_option_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merchandise_option_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merchandise_option_set" do
    assert_difference('MerchandiseOptionSet.count') do
      post :create, :merchandise_option_set => @merchandise_option_set.attributes
    end

    assert_redirected_to merchandise_option_set_path(assigns(:merchandise_option_set))
  end

  test "should show merchandise_option_set" do
    get :show, :id => @merchandise_option_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @merchandise_option_set.to_param
    assert_response :success
  end

  test "should update merchandise_option_set" do
    put :update, :id => @merchandise_option_set.to_param, :merchandise_option_set => @merchandise_option_set.attributes
    assert_redirected_to merchandise_option_set_path(assigns(:merchandise_option_set))
  end

  test "should destroy merchandise_option_set" do
    assert_difference('MerchandiseOptionSet.count', -1) do
      delete :destroy, :id => @merchandise_option_set.to_param
    end

    assert_redirected_to merchandise_option_sets_path
  end
end
