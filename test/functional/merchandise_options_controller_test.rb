require 'test_helper'

class MerchandiseOptionsControllerTest < ActionController::TestCase
  setup do
    @merchandise_option = merchandise_options(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:merchandise_options)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create merchandise_option" do
    assert_difference('MerchandiseOption.count') do
      post :create, :merchandise_option => @merchandise_option.attributes
    end

    assert_redirected_to merchandise_option_path(assigns(:merchandise_option))
  end

  test "should show merchandise_option" do
    get :show, :id => @merchandise_option.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @merchandise_option.to_param
    assert_response :success
  end

  test "should update merchandise_option" do
    put :update, :id => @merchandise_option.to_param, :merchandise_option => @merchandise_option.attributes
    assert_redirected_to merchandise_option_path(assigns(:merchandise_option))
  end

  test "should destroy merchandise_option" do
    assert_difference('MerchandiseOption.count', -1) do
      delete :destroy, :id => @merchandise_option.to_param
    end

    assert_redirected_to merchandise_options_path
  end
end
