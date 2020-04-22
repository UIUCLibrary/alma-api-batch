# AlmaApi

This gem acts as a wrapper around the Alma APIs, enforcing rate limits as well as handling certain errors that can be returned from the API to indicate an overall temporary block due to aggregated institutional usage.  

Since the rate limits are applied at the institution level and not at api key level, this module can be used to handle it if popularity of the apis gets higher.

## Installation

See development for now


## Usage

You'll need a yaml file with configuration information that is used to set up the Api keys and the alma instance you want to connect to.

See [Alma's API Overiew: Calling Alma APIs]( https://developers.exlibrisgroup.com/alma/apis/#calling ) for details on hostname.

The key needs to be a key that has at least read permissions for whatever api you're going to try calling. The module right now doesn't necessarily check though.

See [Alma's API Overview: Creating An Alma API Key]( https://developers.exlibrisgroup.com/alma/apis/#defining ) for detail son creating the api key 

This needs to hae the following:

```
---
url_base: the hostname to connect (in North America, use api-na.hosted.exlibrisgroup.com)
api_key: your_alma_key

```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Dependencies

* This uses the ruby-limiter gem from https://github.com/Shopify/limiter as the main way of controlling the rate of API calls.
## Contributing

Bug reports and pull requests are welcome. 


## TODOS

  * Add this gem to github, point to it in docs.
  
  




