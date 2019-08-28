# README

* Minimum Ruby version 2.4 (use of `.sum` and `.match?`); tested on Ruby 2.4.1 - 2.6.3 on Rails 5.2 - 6.0.0 on MacOS 10.9 - 10.14 and Win 7/10.

* Uses Nokogiri, Bootstrap, Lazyload and Pagy gems. Also uses lazyload.js for lazy image loading, CanvasJS (canvasjs.jquery.min.js) for charts, and popper.js for popovers. 

* It is recommended that this is run in an OS X or Linux-based environment, but it will work, albeit relatively slowly, on Windows as well. Database configuration (in `database.yml`) may need to be tweaked for this to work properly on Windows.

* To initialize database: Boot up your [PostgreSQL](https://www.postgresql.org/download/) app, run rake db:create and rake db:migrate

* After creating and initializing the database, run `bundle install`. (Feel free to delete the gemfile.lock before doing so if you wish.) After doing so, and after adding sets and pricing in the steps detailed below, run the server with `rails s` and navigate to `localhost:3000` in your browser.

**Seeding the Database**
* At some point in the not-too-distant future, there will be a separate seedfile which you will be able to rename seeds.rb and run `rake db:seeds`. At present, however, this is not implemented, both because the final incarnation of the database hasn't yet been determined, and also because there are over 30,000 seeds (some of which are interdependent) which need to be generated, and generated correctly, irrespective of their arbitrary ids.

* At present, the best way to get the database up and running is, after running migrations, to either add a few card sets which you are interested in (e.g. Alpha, Beta, Unlimited, Mirage, Stronghold), and simply go from there. This can be done one at a time fairly comfortably. 

* For example, after dropping into `rails c` and then entering`require './db/seeds.rb'`:

```ruby
  ['LEA', 'LEB', '2ED', 'MIR', 'STH'].each { | set_code | create_set(set_code) }
```

* This creates all cards within the given sets. It is highly recommended that you then follow this by running SetPriceScraper.get_set_prices over each set code in a similar fashion, as shown below (otherwise the site will have limited functionality in many places and not work as expected):

```ruby
  ['LEA', 'LEB', '2ED', 'MIR', 'STH'].each { | set_code | SetPriceScraper.get_set_prices(set_code) }
```

* If you wish to use the Generate Booster Packs feature for Urza's Legacy or newer sets, you will also need to add foil prices to your cards. This can be done similarly as before:

```ruby
  ['set', 'codes', 'here'].each { | set_code | SetPriceScraper.get_set_prices(set_code, 'foil') }
```

* Optionally (and recommended), the same thing can be done with getting all other printings of a given card:

```ruby
  ['<collection of set codes of arbitrary size>'].each { | set_code | get_editions(set_code) }
```

* Please note that get_editions is *quite* a bit slower than either set creation or price scraping, as the external API responsible is fairly slow. Feel free to add per-request threading if you know what you're doing and aren't concerned about dying threads/memory usage, but multithreading isn't built into this particular method (each set returns a lot of data).

* If you decide you wish to add everything at once, please take care with set price scraping. While the set creation API doesn't mind being hit very frequently (it asks you give it at least 10ms between each request), you _will_ receive a time out if you attempt to sequentially scrape prices for one set after the other (most likely from CardKingdom, which unfortunately has its prices for full sets broken up across 2-6 pages, depending on set size, all of which are accessed simultaneously via threading).

* To avoid getting a time out, add some time in between your requests by including `sleep` in your code. You might try something like this: 

```ruby
  AllEditionsStandardCodes.values.each do | set_code |
    create_set(set_code)
    SetPriceScraper.get_set_prices(set_code)
    
    sleep(2.5)
  end

  AllEditionsStandardCodes.values.each do | set_code |
    get_editions(set_code)
  end

  #optionally, in order to use Generate Booster Packs feature with sets that contain foils:
  AllEditionsStandardCodes.values.each do | set_code |
    SetPriceScraper.get_set_prices(set_code, 'foil')
    sleep(2.5)
  end

```

**Set updating**
* From time to time, card data, most noticeably image data, may becomce outdated. If this happens and you're seeing blank images for cropped photos and thumbnails, you can drop into the rails console (`rails c` in bash), type `require './db/seeds.rb`, and then type `update_set('set_code')`, where set_code is the three-letter code for the set which needs updating. For example, `update_set('mir')` will refresh data for the set Mirage from the Scryfall API. (Set codes are found in the CardSets module (`/app/models/concerns/card_sets.rb`)- use the codes found in AllEditionsStandardCodes near the bottom of the file.) 

* Alternatively, if this is too difficult or there are simply many sets that need refreshing, you can additionally type `include CardSets`, then copy and paste the following code into the Rails console:

```ruby
AllEditionsStandardCodes.values.each { | set_code | update_set(set_code) }
```

* This will initiate the process of updating every card set (there are over 100, so it may take some time).