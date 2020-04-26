$LOAD_PATH.unshift File.expand_path("../lib", __dir__)


require 'test/unit'
require 'webmock/test_unit'
require 'alma_api/batch'
require 'uri'


class TestVerbs < Test::Unit::TestCase


  def setup
    
    @api = AlmaApi::Batch::ApiCaller.new('null.library.illinois.edu','fake_api_key')
    
  end
  
  def test_get
    
    stub_get = stub_request(:get, /https:\/\/null.library.illinois.edu.*/).
                 with(headers: { 'Authorize' => 'fake_api_key' })
    
    
    @api.get('vendors') 
    
    
    assert_requested(stub_get)
    
  end
  
  
  def test_get_wtih_query
    
    stub_get = stub_request(:get, /https:\/\/null.library.illinois.edu.*/).
                 with(headers: { 'Authorize' => 'fake_api_key' },
                      query: {"offset" => ["300"],
                              "limit" => ["100"]}) 
    
    
    # leads to good question...any query w/ parameters that are array in Alma api
    @api.get('vendors', {:offset => 300,  :limit => 100 }) 
    
    
    
    assert_requested(stub_get)
  end
  
  def test_post

    body_doc = %q{<vendor><vendor_name>Fake Vendor of Fenders</vendor_name></vendor>}
    
    
      # set up webmock
    stub = stub_request(:post, /https:\/\/null.library.illinois.edu\/some_api_base\/vendors\/0134.*/).
             with(headers: { 'Authorize' => 'fake_api_key' },
                  body: body_doc)
    
    
    @api.post('some_api_base/vendors', body_doc) 
    

    assert_requested(stub)


  end

  def test_put

    
    body_doc = %q{<vendor><vendor_name>Fake Vendor of Fenders</vendor_name></vendor>}
    
    
    # set up webmock
    stub = stub_request(:put, /https:\/\/null.library.illinois.edu\/some_api_base\/vendors\/0134.*/).
             with(headers: { 'Authorize' => 'fake_api_key' },
                  body: body_doc)
    
    
    @api.put('some_api_base/vendors', body_doc) 
    
    
    assert_requested(stub)


  end
  
end
