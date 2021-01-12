# frozen_string_literal: true

module PostcodesIO
  ##
  # Simple struct to return the minimum required data for a search
  Postcode = Struct.new(:code, :lsoa)
end
