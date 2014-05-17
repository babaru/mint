require 'test_helper'

class DropdownButtonCellTest < Cell::TestCase
  test "show" do
    invoke :show
    assert_select "p"
  end
  

end
