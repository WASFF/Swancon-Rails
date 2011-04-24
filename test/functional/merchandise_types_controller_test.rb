require 'test_helper'

class MerchandiseTypesControllerTest < ActionController::TestCase
  setup do
    @merchandise_type = merchandise_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merchandise_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merchandise_type" do
    assert_difference('MerchandiseType.count') do
      post :create, :merchandise_type => @merchandise_type.attributes
    end

    assert_redirected_to merchandise_type_path(assigns(:merchandise_type))
  end

  test "should show merchandise_type" do
    get :show, :id => @merchandise_type.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @merchandise_type.to_param
    assert_response :success
  end

  test "should update merchandise_type" do
    put :update, :id => @merchandise_type.to_param, :merchandise_type => @merchandise_type.attributes
    assert_redirected_to merchandise_type_path(assigns(:merchandise_type))
  end

  test "should destroy merchandise_type" do
    assert_difference('MerchandiseType.count', -1) do
      delete :destroy, :id => @merchandise_type.to_param
    end

    assert_redirected_to merchandise_types_path
  end
end
