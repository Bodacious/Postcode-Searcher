# frozen_string_literal: true

##
# A record with {Postcode} and lsoa stored on the local database. Used when remote API
# doesn't recognise a partcular result, or a result is an exception to the general rules.
#
# StoredPostcode conforms to the repository pattern exected by {PostcodeFinder}.
#
#
# == Schema Information
#
# Table name: stored_postcodes
#
#  id         :integer          not null, primary key
#  lsoa       :string           not null
#  postcode   :string(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stored_postcodes_on_postcode  (postcode) UNIQUE
#
class StoredPostcode < ApplicationRecord
  require 'postcode'

  # ==============================================================================
  # = Validation =
  # ==============================================================================

  validates :lsoa, presence: true

  validates :postcode, presence: true, postcode: true

  # ==============================================================================
  # = Callbacks =
  # ==============================================================================

  before_save :normalize_postcode_format, if: :postcode_changed?

  # ==============================================================================
  # = Class methods =
  # ==============================================================================

  ##
  # Overwrite ActiveRecord's  default `.find()` to conform to the repository pattern
  # expected by {PostcodeFinder}.
  #
  # postcode - A String to seach for, should be in UK {Postcode} format.
  #
  # Returns StoredPostcode
  # Returns nil
  # Raises Postcode::InvalidPostcodeError
  def self.find(postcode)
    find_by(postcode: Postcode.parse(postcode).full)
  end

  private

  ##
  # Ensure {postcode} is in standard format before committing to DB.
  def normalize_postcode_format
    self.postcode = Postcode.parse(postcode).to_s
  end
end
