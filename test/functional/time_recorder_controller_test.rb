require 'test_helper'

class TimeRecorderControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
