# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'PostcodeSearches', type: :system, postcodes_io: true, js: true do
  scenario 'User searches for a valid postcode within service area' do
    stub_postcodes_io_request('SE1 7QD')
    visit root_path
    fill_in :postcode_search_postcode, with: 'SE1 7QD'
    click_button 'Search'
    expect(page).to have_text('We service your area')
  end

  scenario 'User searches for a valid postcode outside service area' do
    stub_postcodes_io_request('EH1 3QB', lsoa: 'Edinburgh')
    visit root_path
    fill_in :postcode_search_postcode, with: 'EH1 3QB'
    click_button 'Search'
    expect(page).to have_text("We don't service your area")
  end

  scenario "User searches for a valid postcode that isn't on Postcodes.io" do
    stub_postcodes_io_fail_request('SH24 1AB')
    visit root_path
    fill_in :postcode_search_postcode, with: 'SH24 1AB'
    click_button 'Search'
    expect(page).to have_text('was not recognised')
  end

  scenario 'User searches for valid postcode that only exists as StoredPostcode' do
    StoredPostcode.create!(postcode: 'SH24 1AA', lsoa: 'Southwark')
    stub_postcodes_io_fail_request('SH24 1AA')
    visit root_path
    fill_in :postcode_search_postcode, with: 'SH24 1AA'
    click_button 'Search'
    expect(page).to have_text('We service your area')
  end

  scenario 'User searches for an ivalid text string' do
    visit root_path
    fill_in :postcode_search_postcode, with: 'Foo-bar'
    click_button 'Search'
    expect(page).to have_text('does not look like a valid postcode')
  end
end
