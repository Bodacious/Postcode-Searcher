# frozen_string_literal: true

require 'spec_helper'
require 'services/postcode_finder'

RSpec.describe PostcodeFinder, type: :service do
  describe '.call' do
    let(:postcode) { 'SE1 7QD' }

    let(:repositories) { [test_repo_1, test_repo_2] }

    let(:result_postcode) do
      double('Result', postcode: postcode, lsoa: 'Southwark')
    end

    TestRepo1 = Class.new do
      def self.find(test_postcode)
        # :noop:
      end
    end

    TestRepo2 = Class.new do
      def self.find(test_postcode)
        # :noop:
      end
    end

    subject { described_class.call(postcode, repositories: repositories) }

    context 'when postcode is valid but repositories empty' do
      let(:repositories) { [] }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when postcode is valid and present in first repository' do
      let(:repositories) { [TestRepo1, TestRepo2].map(&:name) }

      before do
        allow(TestRepo1).to receive(:find).with(postcode).and_return(result_postcode)
      end

      it 'returns a valid postcode result' do
        expect(subject).to eql(result_postcode)
      end

      it "doesn't look in the second repository" do
        expect(TestRepo2).not_to receive(:find)
        subject # run .call()
      end
    end

    context 'when postcode is valid and present in second repository' do
      let(:repositories) { [TestRepo1, TestRepo2].map(&:name) }

      before do
        allow(TestRepo1).to receive(:find).with(postcode).and_return(nil)
        allow(TestRepo2).to receive(:find).with(postcode).and_return(result_postcode)
      end

      it 'returns a valid postcode result' do
        expect(subject).to eql(result_postcode)
      end

      it 'looks in the first repository' do
        expect(TestRepo1).to receive(:find).with(postcode)
        expect(TestRepo2).to receive(:find).with(postcode)
        subject # run .call()
      end
    end
  end
end
