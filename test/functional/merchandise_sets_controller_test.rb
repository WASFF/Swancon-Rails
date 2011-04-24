require 'test_helper'

class MerchandiseSetsControllerTest < ActionController::TestCase
  setup do
    @merchandise_set = merchandise_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merchandise_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merchandise_set" do
    assert_difference('MerchandiseSet.count') do
      post :create, :merchandise_set => @merchandise_set.attributes
    end

    assert_redirected_to merchandise_set_path(assigns(:merchandise_set))
  end

  test "should show merchandise_set" do
    get :show, :id => @merchandise_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @merchandise_set.to_param
    assert_response :success
  end

  test "should update merchandise_set" do
    put :update, :id => @merchandise_set.to_param, :merchandise_set => @merchandise_set.attributes
    assert_redirected_to merchandise_set_path(assigns(:merchandise_set))
  end

  test "should destroy merchandise_set" do
    assert_difference('MerchandiseSet.count', -1) do
      delete :destroy, :id => @merchandise_set.to_param
    end

    assert_redirected_to merchandise_sets_path
  end
end
