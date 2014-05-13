require 'test_helper'

class LabelCellTest < Cell::TestCase
  test "show" do
    invoke :show
    assert_select "p"
  end
  

end
