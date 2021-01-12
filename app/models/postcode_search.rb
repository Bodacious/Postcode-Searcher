# frozen_string_literal: true

##
# Represents a single search for a {Postcode}. Will perform validation to ensure
# search input is valid. Attributes are completed for presenting serach results back to
# user.
class PostcodeSearch
  include ActiveModel::Model
  include ActiveModel::Attributes

  # ==============================================================================
  # = Attributes =
  # ==============================================================================

  ##
  # String attribute containing the lsoa for the given Postcode
  attribute :lsoa, :string

  ##
  # String attribute containing the postcode
  attribute :postcode, :string

  # ==============================================================================
  # = Validations =
  # ==============================================================================

  validates :postcode, postcode: true, presence: true

  # ==============================================================================
  # = Public instance methods =
  # ==============================================================================

  ##
  # Is the {postcode} within a {ServiceableArea}?
  #
  # Returns Boolean
  def in_service_area?
    ServiceableArea.covered?(lsoa.to_s)
  end
end
