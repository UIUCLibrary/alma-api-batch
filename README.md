# AlmaApi

This gem acts as a wrapper around the Alma APIs, enforcing rate limits as well as handling certain errors that can be returned from the API to indicate an overall temporary block due to aggregated institutional usage.  

Since the rate limits are applied at the institution/consortium level and not at api key level, this module can be used to handle it if popularity of the apis gets higher.

## Installation

  1. download from [Alma Api Batch on GitHub](https://github.com/UIUCLibrary/alma-api-batch1.
  1. `cd alma-api-batch`
  1. `gem build alma_api.gemspec`
  1. `gem install alma_api-x.y.z.gem` 
   
## Use with Bundler 

`gem 'alma_api', 'https://github.com/UIUCLibrary/alma-api-batch.git'`




## Usage

Include `require 'alma_api/batch'` at the top of your script/file.


Construct the caller object. This takes care of rate-limiting concerns, both throttling and retrying the call if a response comes back that the threshold was exceeded. (Thresholds are per-institution, not api key, so even if everyone is being responsible they can still happen).

`api_caller = AlmaApi::Batch::ApiCaller.new( one_of_the_alma_sites','alma_api_key' )`


The host will be the alma regional servers. For example, in North America use api-na.hosted.exlibrisgroup.com. See full list at [Alma's API Overview: Calling Alma Apis]( https://developers.exlibrisgroup.com/alma/apis/#structure,

The key needs to be a key that has at least read permissions for whatever api you're going to try calling. The module right now doesn't necessarily check though.

See [Alma's API Overview: Creating An Alma API Key]( https://developers.exlibrisgroup.com/alma/apis/#defining ) for detail son creating the api key 



### Get

    

`api_caller.get( path, query_parameters )`


    * *path* - The path used by the Api docs, as specified in the documentation's tables in the path column
    * *query_paramters* - Any query parameters used in the url.

For example, the vendors api call is paged, so it only returns a limited number of results per call. You need to supply how many you want back (limit), with the upper range allowed being 100) and the row you want to start at (offset).


`response = api_caller.get( '/almaws/v1/acq/vendors', { :offset => 300, :limit => 100 })`


### Put

`api_caller.put( path, body_text, query_parameters )`

    * *path* - The path used by the Api docs, as specified in the documentation's tables in the path column
    * *body_text* - the body of the document to "put"
    * *query_paramters* - Any query parameters used in the url.


For example:
`api_caller.put( '/almaws/v1/acq/vendors/wiley', '<vendor><vendor_name>Wiley</ven...</vendor>' )`



### Post


`api_caller.post( path, body_text, query_parameters )`

    * *path* - The path used by the Api docs, as specified in the documentation's tables in the path column
    * *body_text* - the body of the document to "put"
    * *query_paramters* - Any query parameters used in the url.

For example, `api_caller(  '/almaws/v1/acq/invoices','<invoice>....</invoice>')`

## Development

Run `rake test` to run the tests. 

To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Dependencies

* This uses the ruby-limiter gem from https://github.com/Shopify/limiter as the main way of controlling the rate of API calls.
## Contributing

Bug reports and pull requests are welcome. 


## TODOS

  * Add some higher-level functionality based on existing scripts usage of api calls
  * Have host be part of setup - See [Alma's API Overiew: Calling Alma APIs]( https://developers.exlibrisgroup.com/alma/apis/#calling ) for details on hostname.
  * Add back in bin/console, or better instructions on using it


  
  




