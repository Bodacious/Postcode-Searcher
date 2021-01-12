# frozen_string_literal: true

##
# Represents areas serviceable by us.
#
class ServiceableArea
  ##
  # Regular expression to check if an lsoa is within the servicable area.
  SERVICEABLE_LSOA_REGEX = /\A(
    Lambeth|
    Southwark
  )/x.freeze

  # ==============================================================================
  # = Public class methods =
  # ==============================================================================

  ##
  # Is the given lsoa within a serviceable area?
  #
  # lsoa - String containing a test lsoa
  #
  # Returns Boolean
  def self.covered?(lsoa)
    !!(SERVICEABLE_LSOA_REGEX =~ lsoa.to_s)
  end
end
