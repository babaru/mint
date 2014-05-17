require 'test_helper'

class OvertimeRecordsControllerTest < ActionController::TestCase
  setup do
    @overtime_record = overtime_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:overtime_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create overtime_record" do
    assert_difference('OvertimeRecord.count') do
      post :create, overtime_record: {  }
    end

    assert_redirected_to overtime_record_path(assigns(:overtime_record))
  end

  test "should show overtime_record" do
    get :show, id: @overtime_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @overtime_record
    assert_response :success
  end

  test "should update overtime_record" do
    put :update, id: @overtime_record, overtime_record: {  }
    assert_redirected_to overtime_record_path(assigns(:overtime_record))
  end

  test "should destroy overtime_record" do
    assert_difference('OvertimeRecord.count', -1) do
      delete :destroy, id: @overtime_record
    end

    assert_redirected_to overtime_records_path
  end
end
