module CardPriceUpdate
  def price_empty_or_older_than_24_hours(last_updated, price)
    (Time.now - last_updated) > 24.hours || price.empty?
  end
end