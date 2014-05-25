require 'test_helper'

class LeaveRecordsControllerTest < ActionController::TestCase
  setup do
    @leave_record = leave_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:leave_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create leave_record" do
    assert_difference('LeaveRecord.count') do
      post :create, leave_record: {  }
    end

    assert_redirected_to leave_record_path(assigns(:leave_record))
  end

  test "should show leave_record" do
    get :show, id: @leave_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @leave_record
    assert_response :success
  end

  test "should update leave_record" do
    put :update, id: @leave_record, leave_record: {  }
    assert_redirected_to leave_record_path(assigns(:leave_record))
  end

  test "should destroy leave_record" do
    assert_difference('LeaveRecord.count', -1) do
      delete :destroy, id: @leave_record
    end

    assert_redirected_to leave_records_path
  end
end
