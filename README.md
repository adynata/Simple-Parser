A simple app written in Rails and AngularJS that takes an input and returns it with the following modifications:

* Words with a length that is odd are reversed
* Words with an even length are echoed
* A well-formed url with prefix http:// or https:// is replaced with the prefix removed
* Two floating point numbers separated by comma enclosed by a pair of brackets are assumed to be geolocation coordinate (latitude, longitude). They will be appended with the name of location thru Google Map API lookup.

This app is written in:

* Ruby 2.1.2p95
* Rails 4.2.3
* Postgres
* Angular 1.5.7

Currently the parser assumes that the input does not contain ellipses or other consecutive sequences of punctuation within the text.

##To run locally, make sure you have Postgres running, and then from the CL:
```
git clone https://github.com/adynata/Simple-Parser.git
bundle install
rails s
```
Then navigate to http://localhost:3000/ to see it running.
