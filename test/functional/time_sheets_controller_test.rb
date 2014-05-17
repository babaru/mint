require 'test_helper'

class TimeSheetsControllerTest < ActionController::TestCase
  setup do
    @time_sheet = time_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_sheet" do
    assert_difference('TimeSheet.count') do
      post :create, time_sheet: {  }
    end

    assert_redirected_to time_sheet_path(assigns(:time_sheet))
  end

  test "should show time_sheet" do
    get :show, id: @time_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @time_sheet
    assert_response :success
  end

  test "should update time_sheet" do
    put :update, id: @time_sheet, time_sheet: {  }
    assert_redirected_to time_sheet_path(assigns(:time_sheet))
  end

  test "should destroy time_sheet" do
    assert_difference('TimeSheet.count', -1) do
      delete :destroy, id: @time_sheet
    end

    assert_redirected_to time_sheets_path
  end
end
