# frozen_string_literal: true

require 'spec_helper'
require 'postcode'

RSpec.describe Postcode do
  describe '.parse' do
    subject(:postcode) { described_class.parse(test_string) }

    context 'when string has valid format' do
      let(:test_string) { 'SH24 1AA' }

      it 'creates a new Postcode object' do
        expect(postcode).to be_a(Postcode)
      end

      it 'sets the outward component' do
        expect(postcode.outward).to eql('SH24')
      end

      it 'sets the inward component' do
        expect(postcode.inward).to eql('1AA')
      end

      it 'returns the full postcode as a string' do
        expect(postcode.full).to eql('SH24 1AA')
      end
    end

    context "when postcode is in format 'AA9A 9AA'" do
      subject(:postcode) { Postcode.parse('AA9A 9AA') }

      it 'returns a Postcode object' do
        expect(postcode).to be_a(Postcode)
      end
    end

    context "when postcode is in format 'A9A 9AA'" do
      subject(:postcode) { Postcode.parse('A9A 9AA') }

      it 'returns a Postcode object' do
        expect(postcode).to be_a(Postcode)
      end
    end

    context "when postcode is in format 'A9 9AA'" do
      subject(:postcode) { Postcode.parse('A9 9AA') }

      it 'returns a Postcode object' do
        expect(postcode).to be_a(Postcode)
      end
    end

    context "when postcode is in format 'A99 9AA'" do
      subject(:postcode) { Postcode.parse('A99 9AA') }

      it 'returns a Postcode object' do
        expect(postcode).to be_a(Postcode)
      end
    end

    context "when postcode is in format 'AA9 9AA'" do
      subject(:postcode) { Postcode.parse('AA9 9AA') }

      it 'returns a Postcode object' do
        expect(postcode).to be_a(Postcode)
      end
    end

    context "when postcode is in format 'AA99 9AA'" do
      subject(:postcode) { Postcode.parse('AA99 9AA') }

      it 'returns a Postcode object' do
        expect(postcode).to be_a(Postcode)
      end
    end

    context 'when string has invalid format' do
      let(:test_string) { 'FOO BAR' }

      it 'raises an exception' do
        expect { postcode }.to raise_error('FOO BAR does not look like a valid postcode')
      end
    end

    context 'when the postcode string is in a non-standard format' do
      let(:test_string) { ' sh24 1aA  ' }

      it 'standardises it' do
        expect(postcode.to_s).to eql('SH24 1AA')
      end
    end
  end

  describe '#to_s' do
    subject(:postcode) { described_class.parse('SH24 1AA') }

    it 'returns the full postcode' do
      expect(postcode.to_s).to eql('SH24 1AA')
    end
  end
end
