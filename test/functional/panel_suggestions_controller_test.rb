require 'test_helper'

class PanelSuggestionsControllerTest < ActionController::TestCase
  setup do
    @panel_suggestion = panel_suggestions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:panel_suggestions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create panel_suggestion" do
    assert_difference('PanelSuggestion.count') do
      post :create, :panel_suggestion => @panel_suggestion.attributes
    end

    assert_redirected_to panel_suggestion_path(assigns(:panel_suggestion))
  end

  test "should show panel_suggestion" do
    get :show, :id => @panel_suggestion.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @panel_suggestion.to_param
    assert_response :success
  end

  test "should update panel_suggestion" do
    put :update, :id => @panel_suggestion.to_param, :panel_suggestion => @panel_suggestion.attributes
    assert_redirected_to panel_suggestion_path(assigns(:panel_suggestion))
  end

  test "should destroy panel_suggestion" do
    assert_difference('PanelSuggestion.count', -1) do
      delete :destroy, :id => @panel_suggestion.to_param
    end

    assert_redirected_to panel_suggestions_path
  end
end
