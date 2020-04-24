$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require 'test/unit'
require 'alma_api/error_response'
require 'uri'
require 'nokogiri'


class TestErrorResponse < Test::Unit::TestCase

  def setup

    _error_xml_raw = <<-EOXML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<web_service_result xmlns="http://com/exlibris/urm/general/xmlbeans">
  <errorsExist>true</errorsExist>
  <errorList>
    <error>
      <errorCode>INTERNAL_SERVER_ERROR</errorCode>
      <errorMessage>The web server encountered an unexpected condition that prevented it from fulfilling the request.</errorMessage>
      <trackingId>E01-2303131047-FGBKX-TSE188753689</trackingId>
    </error>
    <error>
      <errorCode>CORE BREACH</errorCode>
      <errorMessage>The crystals will shatter, captain!</errorMessage>
      <trackingId>E01-2303131047-FGBKX-TSE188753698</trackingId>
    </error>
  </errorList>
</web_service_result>
EOXML
    

    @error_xml = Nokogiri::XML( _error_xml_raw ) 

    @error_response = AlmaApi::ErrorResponse.new( @error_xml ) 
  end
  
  def test_error_response_returns_false_when_not_error

    not_error_xml = Nokogiri::XML( '<alma><api><response>Some response</response></api></alma>')

    assert(!AlmaApi::ErrorResponse.error_response?( not_error_xml ), "Not an error response")
  end

  def test_error_response_returns_true_when_error
    
    assert(AlmaApi::ErrorResponse.error_response?( @error_xml ), "Should be considered an error response")
  end


  def test_error_list

    actual_error_list = @error_response.error_list

    assert_equal(2,actual_error_list.size, "error list from test xml should contain two errors")
    
    expected_error_list = [{code: 'INTERNAL_SERVER_ERROR',
                            message: 'The web server encountered an unexpected condition that prevented it from fulfilling the request.',
                            tracking_id: 'E01-2303131047-FGBKX-TSE188753689'
                           },
                           {code: 'CORE BREACH',
                             message: 'The crystals will shatter, captain!',
                             tracking_id: 'E01-2303131047-FGBKX-TSE188753698'
                           }]
    

    assert_equal(expected_error_list.size, actual_error_list.size, "Sizes of expected array and actual array should be the same")

    error_entry_index = 0
    while( error_entry_index < expected_error_list.size)

      assert_equal(expected_error_list[error_entry_index][:code],actual_error_list[error_entry_index][:code] )
      assert_equal(expected_error_list[error_entry_index][:message],actual_error_list[error_entry_index][:message] )
      assert_equal(expected_error_list[error_entry_index][:tracking_id],actual_error_list[error_entry_index][:tracking_id] )
      
      error_entry_index += 1
    end
    
  end
    
end
