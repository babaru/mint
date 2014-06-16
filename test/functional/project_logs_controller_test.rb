require 'test_helper'

class ProjectLogsControllerTest < ActionController::TestCase
  setup do
    @project_log = project_logs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:project_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project_log" do
    assert_difference('ProjectLog.count') do
      post :create, project_log: {  }
    end

    assert_redirected_to project_log_path(assigns(:project_log))
  end

  test "should show project_log" do
    get :show, id: @project_log
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @project_log
    assert_response :success
  end

  test "should update project_log" do
    put :update, id: @project_log, project_log: {  }
    assert_redirected_to project_log_path(assigns(:project_log))
  end

  test "should destroy project_log" do
    assert_difference('ProjectLog.count', -1) do
      delete :destroy, id: @project_log
    end

    assert_redirected_to project_logs_path
  end
end
