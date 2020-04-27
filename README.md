# AlmaApi

This gem acts as a wrapper around the Alma APIs, enforcing rate limits as well as handling certain errors that can be returned from the API to indicate an overall temporary block due to aggregated institutional usage.  

Since the rate limits are applied at the institution level and not at api key level, this module can be used to handle it if popularity of the apis gets higher.

## Installation

See development for now


## Usage

First, construct the caller object. This takes care of rate-limiting concners, both throttling and retrying the call if a response comes back that the threshold was exceeded. (Thresholds are per-institution, not api key, so even if everyone is being responsible they can still happen).

`api\_caller = AlmaApi::Batch::ApiCaller.new( one_of_the_alma_sites','alma\_api\_key' )`


The host will be the alma regional servers. For example, in North America use api-na.hosted.exlibrisgroup.com. See full list at [Alma's API Overview: Calling Alma Apis]( https://developers.exlibrisgroup.com/alma/apis/#structure,

The key needs to be a key that has at least read permissions for whatever api you're going to try calling. The module right now doesn't necessarily check though.

See [Alma's API Overview: Creating An Alma API Key]( https://developers.exlibrisgroup.com/alma/apis/#defining ) for detail son creating the api key 



### Get

    

`api\_caller.get( path, query_parameters )`


    * *path* - The path used by the Api docs, as specified in the documentation's tables in the path column
    * *query_paramters* - Any query parameters used in the url.

For example, the vendors api call is paged, so it only returns a limited number of results per call. You need to supply how many you want back (limit), with the upper range allowed being 100) and the row you want to start at (offset).


`response = api_caller.get( '/almaws/v1/acq/vendors', { :offset => 300, :limit => 100 })`


### Put

`api\_caller.put( path, body_text, query_parameters )`

    * *path* - The path used by the Api docs, as specified in the documentation's tables in the path column
    * *body_text* - the body of the document to "put"
    * *query_paramters* - Any query parameters used in the url.


For example:
`api_caller.put( '/almaws/v1/acq/vendors/wiley', '<vendor><vendor_name>Wiley</ven...</vendor>' )`



### Post


`api\_caller.post( path, body_text, query_parameters )`

    * *path* - The path used by the Api docs, as specified in the documentation's tables in the path column
    * *body_text* - the body of the document to "put"
    * *query_paramters* - Any query parameters used in the url.

For example, `api\_caller(  '/almaws/v1/acq/invoices','<invoice>....</invoice>')

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
  * Add some higher-level functionality based on existing scripts usage of api calls
  * Have host be part of setup - See [Alma's API Overiew: Calling Alma APIs]( https://developers.exlibrisgroup.com/alma/apis/#calling ) for details on hostname.


  
  




