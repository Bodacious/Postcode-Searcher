# frozen_string_literal: true

# == Schema Information
#
# Table name: stored_postcodes
#
#  id         :integer          not null, primary key
#  lsoa       :string           not null
#  postcode   :string(8)        not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_stored_postcodes_on_postcode  (postcode) UNIQUE
#
require 'rails_helper'

RSpec.describe StoredPostcode, type: :model do
  let(:valid_record) { described_class.new(lsoa: 'Some town', postcode: 'ST4 6PO') }

  describe 'validations' do
    include_context 'Postcode validating model'
    it { is_expected.to validate_presence_of(:lsoa) }
  end

  describe 'callbacks' do
    describe 'before saving' do
      it 'sets the postcode to uppercase' do
        valid_record.postcode = 'st4 8po'
        expect { valid_record.save }.to change { valid_record.postcode }.to('ST4 8PO')
      end

      it 'adds a space between the outer and inner in postcode' do
        valid_record.postcode = 'ST48PO'
        expect { valid_record.save }.to change { valid_record.postcode }.to('ST4 8PO')
      end

      it 'strips trailing and leading whitespace from postcode' do
        valid_record.postcode = ' ST4 8PO '
        expect { valid_record.save }.to change { valid_record.postcode }.to('ST4 8PO')
      end

      it "doesn't modify the postcode if validation fails" do
        valid_record.postcode = 'st4 8po'
        valid_record.lsoa = nil
        expect { valid_record.save }.not_to change(valid_record, :postcode)
      end
    end
  end
end
