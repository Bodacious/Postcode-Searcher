# frozen_string_literal: true

require 'spec_helper'
require 'postcodes_io/postcode'

RSpec.describe PostcodesIO::Postcode do
  describe '#postcode' do
    it 'has a member called :code' do
      expect(described_class.members).to include(:code)
    end
  end

  describe '#lsoa' do
    it 'has a member called :lsoa' do
      expect(described_class.members).to include(:lsoa)
    end
  end
end
