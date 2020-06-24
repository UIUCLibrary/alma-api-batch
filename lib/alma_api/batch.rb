module AlmaApi
  module Batch

    require 'limiter'
    require 'nokogiri'
    require 'net/http'

    require 'alma_api/error_response'

    # could consider pulling this out into a separate file
    # and then overriding the constructor, have it take in the error response
    # and use that to produce the message
    
    class DailyThresholdMetError < StandardError ; end


    
    # adding a gem just to track time and limit calls might
    # be overkill, can probably implement ourselves directly...
    
    class ApiCaller
      extend Limiter::Mixin

      DAILY_THRESHOLD_BEHAVIOR_WAIT  = 1
      DAILY_THRESHOLD_BEHAVIOR_ERROR = 2
      
      

      limit_method :call, rate: 19, interval: 1
      


      # do we want to make it an option hash?
      
      def initialize(host, key, options = {})
        if options.key?(:daily_threshold_behavior) and options[:daily_threshold_behavior] == DAILY_THRESHOLD_BEHAVIOR_WAIT
          @daily_threshold_behavior = DAILY_THRESHOLD_BEHAVIOR_WAIT
        else
          # defaults to error for now

          @daily_threshold_behavior = DAILY_THRESHOLD_BEHAVIOR_ERROR
        end
          
        @config = { host: host,
                    api_key: key }
      end 
      
      def sleep_till_midnight
        
        current_time  = Time.now.gmtime
        tomorrow_time = current_time + (24 * 60 * 60)
        tomorrow_time.gmtime
        
        gm_first_second_of_tmorrow = Time.gm(tomorrow_time.year,
                                             tomorrow_time.month,
                                             tomorrow_time.day,
                                             0,
                                             0,
                                             1)

        seconds_till_after_midnight = gm_first_second_of_tmorrow - current_time

        # for quick debugging purposes, should remove or
        # set up logger

        puts "Will sleep for #{seconds_till_after_midnight}"
       
        sleep( seconds_till_after_midnight )
        
      end
      
      # we might want to break out some of the longer stuff into
      # unlimited, doesn't make sense to wait before doing
      # actual request part

      
      def call(url, request,  xml = '', *args)
        # Alma throttles for both overall
        # requests per day as well as per second
        #
        # These are PER INSTITUTION, not per conncoection / api key
        # so even if our throttling is working we might get warnings
        # about exceeding either threshold.
        #
        # If it's the daily , we'll want to do a warning
        # and sleep for the rest of the day...
        #
        # if it's the per_second threshold, we should
        # just wait a second (and issue a warning)

        
        throttled_result = true
        response = nil
        while throttled_result do
          
          #header neeeds to be Authorization: apikey {APIKEY}
          request['Authorization'] = 'apikey ' + @config[:api_key]
          
          response = Net::HTTP.start(url.hostname,
                                     url.port,
                                     :use_ssl => true) { | http |
            http.request( request )
          }

          
          if  response.is_a?  Net::HTTPRedirection
            # so we'd need to clone the request, but then change
            # the host...I think..for now I'm going to assume
            # get request..

            uri = _uri( response['location'])
            request = Net::HTTP::Get.new( uri )
            
            
            response = Net::HTTP.start(uri.host,
                                       url.port,
                                       :use_ssl => true) { | http |
              http.request( request )
            }
          end
          
          
          # so...apparently some calls can return redirects..
          # we should think more about how we do this in the long run
          # like looping for some amount of redirects, etc
          # but for now, if redirect just try one more tiem

          
          raw_xml = response.body
                    
          xml = Nokogiri::XML( raw_xml ) 

          # see daily_threshold.xml for an example of what is returend
          # when we hit the daily threshold (not clear what http code
          # this is relative to midnight GMT
          # see concurrent_threshold.xml (also called per_second_threshold in docs) for example of taht
          # this will be returned w/ a code of 429


          # will need to investigate to see if namespace is actually returned in errors unlike some of the other stuff...
          
          #          daily_threshold_xpath = '
          daily_threshold_xpath = '//ae:web_service_result'


          # since results are normally not namespaced, we may be better off just doing xml.remove_namespaces!
          # rather than trusting the docs that these are actually namespaced
          
          # check for daily limit, sleep til midnight GMT if found
          if !xml.xpath( '/ae:web_service_result/ae:errorList/ae:error/ae:errorCode[contains(text(),"DAILY_THRESHOLD")]',
                         { 'ae' => "http://com/exlibris/urm/general/xmlbeans"} ).empty?
            #puts "Warning - reached daily limit for API, going to sleep"
            
            if @daily_threshold_behavior == DAILY_THRESHOLD_BEHAVIOR_WAIT
              puts "doing the wait behavior"
              sleep_till_midnight()
            else
              puts "doing the raise behavior"
              # consider moving this logic out into the Error class
              error_msg = "Daily threshold limit has been reached for Alma Api calls"
              
              error_response = AlmaApi::ErrorResponse.new( xml )

              error_response.error_list.each do | error_list_item |
                error_msg += "\n Tracking Id: #{error_list_item[:traxocking_id]}, Code: #{error_list_item[:code]}, Message: #{error_list_item[:message] } \n"
              end


              raise DailyThresholdMetError.new( error_msg ) 
            end
              
            
          # check for second limit, sleep till next second if found. Don't need to check body, docs say this always returns 429 if it is triggered
          elsif response.code == '429'
            puts "Warning - reached per-second threshold, going to sleep and try again"
            sleep(1)
            
          else
            throttled_result = false
          end
        end
        
        # for now returning response, api only cares about throttle, not errors, etc atm
        #       puts "Ok, got a response that wasn't throttled, going to return that"
        response
      end


      def _uri( endpoint, query_options = nil)


        if endpoint[0] != '/'
          endpoint = '/' + endpoint
        end
        
        
        # should we worry about double-escaping here?
        
        uri = "https://#{@config[:host]}#{endpoint}"
        
        # At some point need to research how alma tends to handle "array" of options...
        # and possibly do someting smart here
        unless query_options.nil?
          query = query_options.
                    map{ |key,value| "#{key}=#{value}" }.
                    join("&")
          uri += "?#{query}"
        end
        
        URI( URI.escape( uri ) )
      end
      
      def get(endpoint, query_options = {})


        
        uri = _uri( endpoint, query_options)
        request = Net::HTTP::Get.new( uri )


        call( uri , request )
        
      end


      # we could probably refactor some of this w/ put and get,
      # have most of it be teh same, but jus the final call to Net::HTTP::x 
      def post(endpoint, body, query_options = {})
        
        
        # should we worry about double-escaping here?
        
        uri = _uri( endpoint, query_options )
        
        request = Net::HTTP::Post.new( uri ) 
        
        request.body         = body 
        request.content_type = 'application/xml' 
        
        call(uri, request)
        
        
      end
      
      
      def put(endpoint, body, query_options = {})

        
        # should we worry about double-escaping here?
        
        uri = _uri( endpoint, query_options )
        
        request = Net::HTTP::Put.new( uri ) 
        
        request.body         = body 
        request.content_type = 'application/xml' 
        
        call(uri, request)
        
        
      end


    end

  end
end
