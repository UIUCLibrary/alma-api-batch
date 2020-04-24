module AlmaApi
  class ErrorResponse

    # expect a nokogiri xml object
    
    def self.error_response?( response_xml )
      response_xml.xpath( '/ae:web_service_result/ae:errorsExist', { 'ae' => "http://com/exlibris/urm/general/xmlbeans"} ).text.downcase == 'true'
    end

    def initialize( response_xml )
      @response_xml = response_xml
    end

    # returns array of hashes, based off of errorList in xml
    def error_list
      error_list = []
      @response_xml.xpath( '/ae:web_service_result/ae:errorList/ae:error', { 'ae' => "http://com/exlibris/urm/general/xmlbeans"} ).each do | error_node |
        
        error_list.push({
                          code:     error_node.xpath('ae:errorCode', { 'ae' => "http://com/exlibris/urm/general/xmlbeans"} ).text ,
                          message:  error_node.xpath('ae:errorMessage', { 'ae' => "http://com/exlibris/urm/general/xmlbeans"} ).text ,
                          tracking_id: error_node.xpath('ae:trackingId', { 'ae' => "http://com/exlibris/urm/general/xmlbeans"} ).text 
                        }) ;

      end

      error_list
    end
    
  end
end
