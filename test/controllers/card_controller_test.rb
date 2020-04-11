require 'test_helper'

class CardControllerTest < ActionDispatch::IntegrationTest
  test "should get reserved list" do
    get '/cards/reserved_list'

    assert_equal "reserved_list", @controller.action_name

    assert_match "Reserved List", @response.body
  end

  test "Should get root path as home" do    
    get root_path
    
    assert_equal "home", @controller.action_name
    assert_match "Card Search", @response.body
  end
end