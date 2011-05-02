require 'test_helper'

class VendorOrdersControllerTest < ActionController::TestCase
  setup do
    @vendor_order = vendor_orders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vendor_orders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vendor_order" do
    assert_difference('VendorOrder.count') do
      post :create, :vendor_order => @vendor_order.attributes
    end

    assert_redirected_to vendor_order_path(assigns(:vendor_order))
  end

  test "should show vendor_order" do
    get :show, :id => @vendor_order.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @vendor_order.to_param
    assert_response :success
  end

  test "should update vendor_order" do
    put :update, :id => @vendor_order.to_param, :vendor_order => @vendor_order.attributes
    assert_redirected_to vendor_order_path(assigns(:vendor_order))
  end

  test "should destroy vendor_order" do
    assert_difference('VendorOrder.count', -1) do
      delete :destroy, :id => @vendor_order.to_param
    end

    assert_redirected_to vendor_orders_path
  end
end
