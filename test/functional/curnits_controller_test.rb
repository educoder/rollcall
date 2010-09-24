require 'test_helper'

class CurnitsControllerTest < ActionController::TestCase
  setup do
    @curnit = curnits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:curnits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create curnit" do
    assert_difference('Curnit.count') do
      post :create, :curnit => @curnit.attributes
    end

    assert_redirected_to curnit_path(assigns(:curnit))
  end

  test "should show curnit" do
    get :show, :id => @curnit.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @curnit.to_param
    assert_response :success
  end

  test "should update curnit" do
    put :update, :id => @curnit.to_param, :curnit => @curnit.attributes
    assert_redirected_to curnit_path(assigns(:curnit))
  end

  test "should destroy curnit" do
    assert_difference('Curnit.count', -1) do
      delete :destroy, :id => @curnit.to_param
    end

    assert_redirected_to curnits_path
  end
end
