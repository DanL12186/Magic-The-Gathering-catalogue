# README

* Minimum Ruby version 2.4 (use of `.sum` and `.match?`); tested on Ruby 2.4.1 - 2.6.0 on Rails 5.2 - 5.2.3 on MacOS 10.9 - 10.14 and Win 7/10.

* Uses Nokogiri, Bootstrap, Lazyload and Pagy gems. Also uses lazyload.js for lazy image loading, CanvasJS (canvasjs.jquery.min.js) for charts, and popper.js for popovers. 

* Configuration

* To initialize database: Boot up PostGreSQL app, run rake db:create and rake db:migrate

* How to run the test suite

* Deployment instructions

**Set updating**
* From time to time, card data, most noticeably image data, may becomce outdated. If this happens and you're seeing blank images for cropped photos and thumbnails, you can drop into the rails console (`rails c` in bash), type `require './db/seeds.rb`, and then type `update_set('set_code')`, where set_code is the three-letter code for the set which needs updating. For example, `update_set('mir')` will refresh data for the set Mirage from the Scryfall API. (Set codes are found in the CardSets module (`/app/models/concerns/card_sets.rb`)- use the codes found in AllEditionsStandardCodes near the bottom of the file.) 

* Alternatively, if this is too difficult or there are simply many sets that need refreshing, you can additionally type `include CardSets`, then copy and paste the following code into the Rails console:

```ruby
AllEditionsStandardCodes.values.each do | code | 
  update_set(code)
end
```

* This will initiate the process of updating every card set (there are over 100, so it may take some time).