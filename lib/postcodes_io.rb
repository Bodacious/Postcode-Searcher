# frozen_string_literal: true

##
# Connects to the PostcodesIO API to perform searches.
#
# Examples
#
#   PostcodesIO.find("SE1 7QD") # => <PostcodesIO::Postcode postcode="SE1 7QD" lsoa="...">
#
module PostcodesIO
  # Load API models below
  require 'postcodes_io/request'
  require 'postcode'

  module_function

  ##
  # Conform to PostcodeFinder's repository API
  #
  # string - {Postcode} String to search on
  #
  # Returns {PostcodesIO::Postcode}
  # Returns nil
  def find(string)
    string = ::Postcode.parse(string).to_s
    Request.new(string).result
  end
end
