# frozen_string_literal: true

class PostcodeSearchesController < ApplicationController
  require 'postcodes_io'

  prepend_view_path 'app/views/postcode_searches'

  def new
    @postcode_search = PostcodeSearch.new
  end

  def create
    @postcode_search = PostcodeSearch.new(postcode_search_params)
    # Invalid user input...
    render(template: 'create/error', status: :unprocessable_entity) and return if @postcode_search.invalid?

    # Valid user input, search API and local storage for Postcode result...
    @found_postcode = find_postcode(@postcode_search.postcode)
    # Result found from repositories...
    if @found_postcode
      @postcode_search.lsoa = @found_postcode.lsoa
      render template: 'create/success'
    else
      # No result found in repositories
      render template: 'create/failure', status: :not_found
    end
  end

  private

  def postcode_search_params
    params.require(:postcode_search).permit(:postcode)
  end

  def find_postcode(postcode)
    # Give local storage priority over API:
    PostcodeFinder.call(postcode, repositories: %i[StoredPostcode PostcodesIO])
  end
end
