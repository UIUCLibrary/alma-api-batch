$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'test/unit'
require 'alma_api/batch'
require 'uri'
require 'nokogiri'

# so, need to handle weird redirect behavior
# using actual call out as not positive how the
# redirect actually behaves..

class TestItembarcode < Test::Unit::TestCase

  def setup
     @api = AlmaApi::Batch::ApiCaller.new(ENV['ALMA_HOST'], ENV['ALMA_API_KEY'])
  end
  def test_fetch_by_item_barcode
    WebMock.allow_net_connect!

    fetch_response = @api.get('/almaws/v1/items',{ 'item_barcode' => '30112071950551' } )

    xml_doc = Nokogiri::XML( fetch_response.body )

    assert(xml_doc.xpath('/item').size > 0)

    # /item/bib_data/title
  
   
    WebMock.disable_net_connect!
    
  end
end
