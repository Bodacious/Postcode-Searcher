# frozen_string_literal: true

module PostcodesIO
  ##
  # Performs a single search request to the postcodes.io database
  class Request
    require 'faraday'
    require 'postcode'
    require 'postcodes_io/postcode'
    require 'postcodes_io/response_decorator'

    ##
    # Base URL for Postcodes.io
    API_BASE = 'https://api.postcodes.io'

    ##
    # Headers to send with HTTP request
    HEADERS = { 'Content-Type' => 'application/json' }.freeze

    ##
    # Template String for request path
    PATH = 'postcodes/%{test_code}'

    private_constant :API_BASE, :HEADERS, :PATH

    ##
    # A {PostcodesIO::ResponseDecorator} object once the request has been performed
    attr_accessor :response
    protected :response=

    ##
    # A {PostcodesIO::Postcode} object once the request has been performed successfully
    attr_accessor :result
    protected :result=

    ##
    # String to perform search for
    attr_reader :test_code
    private :test_code

    ##
    # Perform a new search on postcodes.io
    #
    # test_code - The test String to search for
    def initialize(test_code)
      @test_code = ::Postcode.parse(test_code).to_s.delete(' ')
      perform!
    end

    private

    ##
    # Perform the remote request. If a result is found, set {result} to this value
    def perform!
      begin
        faraday_response = connection.get(format(PATH, test_code: test_code.delete(' ')))
        self.response = ResponseDecorator.new(faraday_response)
        self.result = (PostcodesIO::Postcode.new(response.postcode, response.lsoa) if response.success?)
      rescue Faraday::ConnectionFailed
        # :noop:
      end
    end

    def connection
      @connection ||= Faraday.new(url: API_BASE, headers: HEADERS)
    end
  end
end
