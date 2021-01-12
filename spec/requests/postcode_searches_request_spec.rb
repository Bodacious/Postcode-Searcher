# frozen_string_literal: true

require 'rails_helper'
require 'oj'
require 'rspec/json_expectations'

RSpec.describe 'PostcodeSearches', type: :request, postcodes_io: true do
  describe 'GET /' do
    it 'returns http success' do
      get '/'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST /postcode_searches.json' do
    let(:response_body) { Oj.load(response.body) }

    let(:params) do
      { postcode_search: { postcode: postcode } }
    end

    def do_post
      post '/postcode_searches.json', params: params
    end

    context 'with a valid UK postcode in service area' do
      let(:postcode) { 'SE1 7QD' }

      before do
        stub_postcodes_io_request(postcode, { lsoa: 'Southwark 034A' })
        do_post
      end

      it 'contains the postcode and serviceable in the response' do
        expect(response_body).to include_json({
                                                postcode: postcode,
                                                in_service_area: true,
                                                lsoa: 'Southwark 034A'
                                              })
      end

      it 'resonds with 200 (OK)' do
        expect(response).to be_ok
      end
    end

    context 'with a valid UK postcode out of service area' do
      let(:postcode) { 'KY2 6NN' }

      before do
        stub_postcodes_io_request(postcode, { lsoa: 'Craigmount and Greenloanings' })
        do_post
      end

      it 'contains the postcode and serviceable in the response' do
        expect(response_body).to include_json({
                                                postcode: postcode,
                                                in_service_area: false,
                                                lsoa: 'Craigmount and Greenloanings'
                                              })
      end

      it 'resonds with 200 (OK)' do
        expect(response).to be_ok
      end
    end

    context 'with a postcode saved as StoredPostcode' do
      let(:postcode) { 'SH24 1AA' }

      before do
        StoredPostcode.create!(postcode: postcode, lsoa: 'Southwark')
        stub_postcodes_io_fail_request(postcode)
        do_post
      end

      it 'contains the postcode and serviceable in the response' do
        expect(response_body).to include_json({
                                                postcode: postcode,
                                                in_service_area: true,
                                                lsoa: 'Southwark'
                                              })
      end

      it 'resonds with 200 (OK)' do
        expect(response).to be_ok
      end
    end

    context 'with an unrecognised postcode' do
      let(:postcode) { 'SH24 1AB' }

      before do
        stub_postcodes_io_fail_request(postcode)
        do_post
      end

      it 'contains an error describing the postcode' do
        expect(response_body).to include_json({ errors: {
                                                postcode: ['was not recognised']
                                              } })
      end

      it 'resonds with a 404 (Not Found) status' do
        expect(response).to be_not_found
      end
    end

    context 'with an invalid string' do
      let(:postcode) { 'foo-bar' }

      before do
        do_post
      end

      it 'contains an error describing the postcode' do
        expect(response_body).to include_json({ errors: {
                                                postcode: ['does not look like a valid postcode']
                                              } })
      end

      it 'resonds with an unprocessable_entity status' do
        expect(response).to be_unprocessable
      end
    end
  end
end
