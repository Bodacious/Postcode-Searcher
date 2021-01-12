# frozen_string_literal: true

##
# ActiveModel validator to test if an attribute is a valid UK postcode
#
class PostcodeValidator < ActiveModel::EachValidator
  require 'postcode'

  ##
  # Error to add to attribute if not valid
  DEFAULT_ERROR_MESSAGE = 'does not look like a valid postcode'

  def validate_each(record, attribute, value)
    return nil if Postcode.parse(value)
  rescue Postcode::InvalidPostcodeError
    record.errors.add attribute, (options[:message] || DEFAULT_ERROR_MESSAGE)
  end
end
