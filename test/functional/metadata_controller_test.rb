require 'test_helper'

class MetadataControllerTest < ActionController::TestCase
  setup do
    @metadata = metadata(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:metadata)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create metadata" do
    assert_difference('Metadata.count') do
      post :create, :metadata => @metadata.attributes
    end

    assert_redirected_to metadata_path(assigns(:metadata))
  end

  test "should show metadata" do
    get :show, :id => @metadata.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @metadata.to_param
    assert_response :success
  end

  test "should update metadata" do
    put :update, :id => @metadata.to_param, :metadata => @metadata.attributes
    assert_redirected_to metadata_path(assigns(:metadata))
  end

  test "should destroy metadata" do
    assert_difference('Metadata.count', -1) do
      delete :destroy, :id => @metadata.to_param
    end

    assert_redirected_to metadata_path
  end
end
