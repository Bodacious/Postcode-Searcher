# frozen_string_literal: true

##
# Represents a real-world UK postal code.
#
# Examples
#
#   @postcode = Postcode.parse("SH24 1AA") # => <Postcode>
class Postcode

  ##
  # Regular expression to match mainland UK postcodes.
  #
  # If channel islands and other non-mainland formats are required, please see here:
  # https://en.wikipedia.org/wiki/Postcodes_in_the_United_Kingdom#Validation
  FORMAT_REGEXP = /\A
    (?<outward>[A-Z]{1,2}[0-9][A-Z0-9]?) # match the outward component
    \s?                                  # match an optional space
    (?<inward>[0-9][A-Z]{2})             # match the inward component
    \Z/x.freeze

  ##
  # Template String for standard formatting
  TEMPLATE = '%{outward} %{inward}'

  ##
  # Exception raised when input format is not valid
  class InvalidPostcodeError < StandardError
    MESSAGE_TEMPLATE = '%{postcode} does not look like a valid postcode'

    def initialize(postcode)
      super(format(MESSAGE_TEMPLATE, postcode: postcode))
    end
  end

  class << self
    ##
    # Parse a given String as a UK {Postcode}.
    #
    # string - The input String to parse
    #
    # Returns {Postcode}
    # Raises {Postcode::InvalidPostcodeError}
    def parse(string)
      standardised_string = string.to_s.delete(' ').upcase
      result = FORMAT_REGEXP.match(standardised_string)
      raise(InvalidPostcodeError, string) unless result

      new(outward: result[:outward], inward: result[:inward])
    end
  end

  private_class_method :new

  ##
  # String containing the inward code
  attr_reader :inward

  ##
  # String containing the outward code
  attr_reader :outward

  ##
  # String containing the full postcode in standard format (See {TEMPLATE})
  attr_reader :full
  alias to_s full

  # ==============================================================================
  # = Private instance methods =
  # ==============================================================================

  private

  def initialize(outward: nil, inward: nil)
    @outward = outward
    @inward = inward
    @full = format(TEMPLATE, outward: outward, inward: inward)
  end
end
