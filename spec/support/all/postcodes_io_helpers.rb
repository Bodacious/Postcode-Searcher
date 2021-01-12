# frozen_string_literal: true

##
# Helper methods for testing items the include PostcodesIO.
# Add `postcodes_io: true` to spec definition to include
module PostcodesIOHelpers
  require 'active_support/core_ext/hash'
  require 'postcode'
  require 'json'

  URL = 'https://api.postcodes.io/postcodes/%{postcode}'

  REQUEST_HEADERS = { 'Content-Type' => 'application/json' }.freeze

  ERROR_RESPONSE_BODY = { 'status' => 404, 'error' => 'Postcode not found' }.to_json

  def stub_postcodes_io_fail_request(postcode)
    stub_request(:get, format(URL, postcode: postcode.delete(' ')))
      .with(headers: REQUEST_HEADERS)
      .to_return(status: 404, body: ERROR_RESPONSE_BODY)
  end

  def stub_postcodes_io_request(postcode, **attrs)
    stub_request(:get, format(URL, postcode: Postcode.parse(postcode).to_s.delete(' ')))
      .with(headers: REQUEST_HEADERS)
      .to_return(status: 200, body: {
        'status' => 200,
        'result' => {
          'postcode' => postcode,
          'quality' => 1,
          'eastings' => 531_513,
          'northings' => 179_395,
          'country' => 'England',
          'nhs_ha' => 'London',
          'longitude' => -0.106793,
          'latitude' => 51.498204,
          'european_electoral_region' => 'London',
          'primary_care_trust' => 'Southwark',
          'region' => 'London',
          'lsoa' => 'Southwark 034A',
          'msoa' => 'Southwark 034',
          'incode' => '7QD',
          'outcode' => 'SE1',
          'parliamentary_constituency' => 'Bermondsey and Old Southwark', 'admin_district' => 'Southwark',
          'parish' => 'Southwark, unparished area',
          'admin_county' => nil,
          'admin_ward' => "St George's",
          'ced' => nil,
          'ccg' => 'NHS South East London',
          'nuts' => 'Lewisham and Southwark',
          'codes' => {
            'admin_district' => 'E09000028',
            'admin_county' => 'E99999999',
            'admin_ward' => 'E05011114',
            'parish' => 'E43000218',
            'parliamentary_constituency' => 'E14000553',
            'ccg' => 'E38000244',
            'ccg_id' => '72Q',
            'ced' => 'E99999999',
            'nuts' => 'UKI44',
            'lsoa' => 'E01003930',
            'msoa' => 'E02006802',
            'lau2' => 'E05011114'
          }
        }.deep_merge(attrs.deep_transform_keys!(&:to_s))
      }.to_json)
  end
end

RSpec.configure do |config|
  config.include(PostcodesIOHelpers, postcodes_io: true)
end
