require 'test_helper'

class TicketSetsControllerTest < ActionController::TestCase
  setup do
    @ticket_set = ticket_sets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ticket_sets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket_set" do
    assert_difference('TicketSet.count') do
      post :create, :ticket_set => @ticket_set.attributes
    end

    assert_redirected_to ticket_set_path(assigns(:ticket_set))
  end

  test "should show ticket_set" do
    get :show, :id => @ticket_set.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ticket_set.to_param
    assert_response :success
  end

  test "should update ticket_set" do
    put :update, :id => @ticket_set.to_param, :ticket_set => @ticket_set.attributes
    assert_redirected_to ticket_set_path(assigns(:ticket_set))
  end

  test "should destroy ticket_set" do
    assert_difference('TicketSet.count', -1) do
      delete :destroy, :id => @ticket_set.to_param
    end

    assert_redirected_to ticket_sets_path
  end
end
