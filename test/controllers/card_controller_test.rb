require 'test_helper'

class CardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cards_path

    assert_equal "index", @controller.action_name
    assert_match "Partial Matches:", @response.body
  end

  test "Should get root path as home" do    
    get root_path
    
    assert_equal "home", @controller.action_name
    assert_match "Find a Card", @response.body
  end

  test "Should load the appropriate card and cache prices by saving to db once scraped" do
    card = Card.new(name: "Mox Diamond", edition: "Stronghold")
    card.save

    start = Time.now
    get card_path(card)
    finish = Time.now

    uncached_page_load = finish - start

    start = Time.now
    get card_path(card)
    finish = Time.now

    cached_page_load = finish - start

    puts "Uncached: #{uncached_page_load}, Cached: #{cached_page_load}"
    assert (cached_page_load * 100) < (uncached_page_load)
    assert @response.body.include?("Mox Diamond")    
  end
end