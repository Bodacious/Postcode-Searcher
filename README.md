# Postcode searcher

A technical test submission by [Gavin Morrice](https://github.com/Bodacious).

## Install the gems

Make sure you have all of the dependencies required by running `bundle install`.

The app is built using Ruby 2.7.2, and the Gemfile expects this version of Ruby.

## Setup the database

To get started, run `rails db:setup`. This will create a local dev and test database (sqlite3) and seed the database with two `StoredPostcode` records.

## Run the app

This is a typical Rails 6.1 setup, [with the unused libraries removed](https://github.com/Bodacious/Postcode-Searcher/blob/main/config/application.rb#L3-L7). You can run the server locally with `rails server`.

Type in a value to the form field and click "Search" to find out if a postcode is within the service area.

## Run the tests

The code is tested using RSpec. To run the tests, use `rspec spec`. Please note the [_gotcha_ concerning Webmock](https://github.com/Bodacious/Postcode-Searcher#webmock).

## Create documentation

This README and the documentation for the app can be viewed in a more readable format by running:

```
yard doc --plugin tomdoc --hide-void-return --title "Postcode Search" --markup=markdown --markup-provider=kramdown --readme=README.md
```

The above command will create HTML at `doc/index.html` which you can view in your browser.

The code is documented using the [TomDoc format](https://tomdoc.org).

## Notes

### Postcodes IO Gem

I noticed there's already a [postcodes IO gem](https://github.com/jamesruston/postcodes_io). In a real-world setting, I would probably have opted for that, assuming it still works well. I felt that using that in this case would have missed the point of the technical assessment, so I coded my own solution.

### Repository pattern

The brief describes two separate places in which to search for data relating to a single search (locally, and the remote API). I approached this problem by injecting these two _repositories_ into the search service object as a parameter (See PostcodeFinder). This made it easier to test my service object in isolation, while also providing a scalable design pattern for adding future data repositories (which might include a cache store or alternative remote service).

### Postcode object

I defined a Postcode class in the base lib directory as a single source of truth for _postcodes_ within the system. I felt this approach, rather than just using strings everywhere, would be easier to maintain as the system grows and future requirements change.

I opted for an `Object.parse` pattern, since it's a commonly used ruby idiom (e.g. Date, URI, etc.), and provides out-of-the box compatibility with various libraries (e.g. the Grape API library).

### StoredPostcode

The brief states that specified unrecognised postcodes, or specified postcodes outside of the service areas should still be supported by the system. The StoredPostcode model is a simple, local data store that provides this functionality. Records must have a valid UK postcode format, but can have any LSOA—which can be used to cater to postcodes for which the real LSOA is outside the service area.

Local storage is searched before the postcodes.io database so that LSOA values can be overwritten if desired (i.e. to support a postcode outside the service area).

### ServiceableArea

It seemed like overkill to create a database table and model for ServiceableArea when there are really only two qualifying cases. But I extracted this concept out into a logical place so that it can easily be extended with a database etc. in future if the requirements change.

### WebMock

Webmock, annoyingly, will try to update driver versions while you run your tests. If you're also blocking external requests (which I do in this app) then this is blocked and will result in a confusing error about Chrome or Mozilla. To fix this, comment out the `WebMock.disable_net_connect!(allow_localhost: true)` and uncomment the line below `WebMock.allow_net_connect!` then run the tests again. Once the drivers have been updated, remember to switch those configurations back to the way they were.

### Outward searches only

Unfortunately, I didn't have as much time to commit to investigating this problem as I would have liked. But I would have been curious to learn more about the requirements, and also about how postcodes work, to see if the scale of the problem could be greatly reduced by searching only the "outward" component of a postcode—of which there are far fewer.
