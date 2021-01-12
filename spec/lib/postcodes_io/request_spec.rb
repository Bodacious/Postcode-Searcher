# frozen_string_literal: true

require 'spec_helper'
require 'postcodes_io/request'

RSpec.describe PostcodesIO::Request, postcodes_io: true do
  describe '.new' do
    it 'performs the request on initialize' do
      expect_any_instance_of(described_class).to receive(:perform!).and_return(nil)
      described_class.new('SE1 7QD')
    end

    context 'when postcode valid format' do
      it 'calls the postcodes.io API' do
        stub_postcodes_io_request('SE1 7QD')
        described_class.new('SE1 7QD')
      end

      it 'sets the #result value' do
        stub_postcodes_io_request('SE1 7QD')
        expect(described_class.new('SE1 7QD').result).to be_present
      end
    end

    context 'when postcode is valid but not recognised' do
      it 'calls the postcodes.io API' do
        stub_postcodes_io_fail_request('SE1 7QD')
        described_class.new('SE1 7QD')
      end

      it 'sets the #result value as nil' do
        stub_postcodes_io_fail_request('SE1 7QD')
        expect(described_class.new('SE1 7QD').result).to be_nil
      end
    end

    context "when postcode isn't valid format" do
      it 'is expected to raise an exception' do
        expect { described_class.new('foobar') }.to raise_error(Postcode::InvalidPostcodeError)
      end
    end
  end
end
