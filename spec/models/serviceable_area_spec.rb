# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceableArea do
  describe '.covered?' do
    subject(:result) { described_class.covered?(lsoa) }

    context "when value begins with 'Southwark'" do
      let(:lsoa) { 'Southwark 123' }

      it 'returns true' do
        expect(result).to be(true)
      end
    end
    context "when value begins with 'Lambeth'" do
      let(:lsoa) { 'Lambeth 456' }

      it 'returns true' do
        expect(result).to be(true)
      end
    end
    context "when value begins with 'Edinburgh'" do
      let(:lsoa) { 'Edinburgh 789' }

      it 'returns false' do
        expect(result).to be(false)
      end
    end
  end
end
