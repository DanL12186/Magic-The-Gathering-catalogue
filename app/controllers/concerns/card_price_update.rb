module CardPriceUpdate
  def price_empty_or_older_than_24_hours(last_updated, price)
    older_than_24_hours(last_updated) || price.empty?
  end

  def older_than_24_hours(last_updated)
    (Time.now - last_updated) > 24.hours
  end
end