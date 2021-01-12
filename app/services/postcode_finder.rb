# frozen_string_literal: true

##
# Service object for finding postcode results over a range of given repositories.
#   Conforming repositories must meet the following three requirements:
#
#     1. Define a class-level method called .find() which accepts a String
#     2. Return an object that has matching postcode and lsoa attributes
#     3. Return nil if record not found
#
# Examples
#
#  # Search a hypothetical Redis store for cached values
#  class RedisRepo
#    def self.find(postcode)
#      postcode, lsoa = redis.read(postcode)
#      Struct.new(:postcode, :lsoa).new(postcode, lsoa)
#    end
#  end
#  @result = PostcodeFinder.call("SE1 7QD", repositories: ["RedisRepo"])
#  @result # => <struct postcode="SE1 7QD", lsoa="RedisRepo">
#
class PostcodeFinder
  require 'postcode'
  require 'postcodes_io'

  # ==============================================================================
  # = Public class methods =
  # ==============================================================================

  ##
  # Perform a new search. Repositories are injected at method call as class names. This
  #   provides the flexibility to search in multiple places, easy isolation for testing,
  #   and multi-thread support (using class names instead of classes).
  #
  # string - The {Postcode} String we're searching for
  # repositories - Array containing the names of one or more repository class to search in
  #
  # Returns Object
  # Returns nil
  def self.call(string, repositories: [])
    new(string, repositories: repositories).call
  end

  # ==============================================================================
  # = Public instance methods =
  # ==============================================================================

  ##
  # Perform the search in each repository
  def call
    postcode = ::Postcode.parse(string)
    repositories.each do |class_name|
      break if result

      repo_class = Module.const_get(class_name)
      self.result = repo_class.find(postcode.to_s)
    end
    result
  end

  # ==============================================================================
  # = Protected instance methods =
  # ==============================================================================

  ##
  # First result found in any of the repositories
  attr_accessor :result
  protected :result

  # ==============================================================================
  # = Private instance methods =
  # ==============================================================================

  private

  ##
  # Create a new instance of PostcodeFinder. Do not call directly-service objects should
  # be single-use and immutable.
  #
  def initialize(string, repositories: [])
    @string = string
    @repositories = repositories
  end
  private_class_method :new

  ##
  # String to serach for
  attr_reader :string

  ##
  # Array of the repository class names, in order of where to search first
  attr_reader :repositories
end
