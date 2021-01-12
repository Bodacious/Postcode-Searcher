# frozen_string_literal: true

module PostcodesIO
  ##
  # Wraps a Faraday::Response object in some convenience methods
  class ResponseDecorator
    require 'oj'
    require 'forwardable'
    extend Forwardable

    ##
    # Response body as a JSON String
    def_delegator :response, :body, :json_body
    private :json_body

    ##
    # Response status code
    def_delegator :response, :status
    private :status

    ##
    # Was the response a success?
    def_delegator :response, :success?

    ##
    # Faraday::Response object
    attr_reader :response
    private :response

    ##
    # Create a new ResponseDecorator
    #
    # response - Faraday::Response object
    def initialize(response)
      @response = response
    end

    ##
    # Response data as a Ruby Hash
    #
    # Returns Hash
    def body
      success? ? hash_body['result'] : {}
    end

    ##
    # LSOA data from the response body
    #
    # Returns String
    # Returns nil
    def lsoa
      body['lsoa']
    end

    ##
    # Postcode data from the response body
    #
    # Returns String
    # Returns nil
    def postcode
      body['postcode']
    end

    ##
    # Error messages from the response body
    #
    # Returns String
    # Returns nil
    def error_message
      hash_body['error'] unless success?
    end

    private

    ##
    # Load JSON body as a Hash
    #
    # Returns Hash
    def hash_body
      @hash_body ||= Oj.load(json_body)
    end
  end
end
