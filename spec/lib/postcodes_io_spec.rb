# frozen_string_literal: true

require 'spec_helper'
require 'postcodes_io'

RSpec.describe PostcodesIO, :postcodes_io do
  describe '.find' do
    context 'when postcode is recognised' do
      let(:postcode) { 'SE1 7QD' }

      subject(:result) { described_class.find(postcode) }

      before do
        stub_postcodes_io_request(postcode, lsoa: 'Southwark 034A')
      end

      it 'returns a PostcodesIO::Postcode object' do
        expect(result).to be_a(PostcodesIO::Postcode)
      end

      it 'sets the correct code for Postcode' do
        expect(result.code).to eql(postcode)
      end

      it 'sets the correct lsoa for Postcode' do
        expect(result.lsoa).to eql('Southwark 034A')
      end
    end

    context 'when postcode is not recognised' do
      let(:postcode) { 'SH24 1AA' }

      subject(:result) { described_class.find(postcode) }

      before do
        stub_postcodes_io_fail_request(postcode)
      end

      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when postcode is not valid format' do
      let(:postcode) { 'FOOBAR' }

      subject(:result) { described_class.find(postcode) }

      before do
        stub_postcodes_io_fail_request(postcode)
      end

      it 'raises an UnsuccessfulError exception' do
        expect { result }.to raise_error('FOOBAR does not look like a valid postcode')
      end
    end
  end
end
