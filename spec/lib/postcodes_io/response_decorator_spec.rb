# frozen_string_literal: true

require 'spec_helper'
require 'postcodes_io/response_decorator'

RSpec.describe PostcodesIO::ResponseDecorator do
  let(:stub_response) do
    double('Faraday Response', success?: response_success, body: body)
  end

  let(:response_success) { true }

  let(:body) { '{}' }

  subject { described_class.new(stub_response) }

  describe '#success?' do
    context 'when response object is success' do
      let(:response_success) { true }

      it { is_expected.to be_success }
    end

    context 'when response object is not success' do
      let(:response_success) { false }

      it { is_expected.not_to be_success }
    end
  end

  describe '#body' do
    context 'when is success' do
      let(:body) { { result: { foo: 'bar' } }.to_json }

      before do
        allow(subject).to receive(:success?).and_return(true)
      end

      it 'returns the JSON node called "result"' do
        expect(subject.body).to eql({ 'foo' => 'bar' })
      end

      it 'returns a Hash' do
        expect(subject.body).to be_a(Hash)
      end
    end

    context 'when is not success' do
      let(:body) { '{"status":404,"error":"Postcode not found"}' }

      before do
        allow(subject).to receive(:success?).and_return(false)
      end

      it 'returns an empty Hash' do
        expect(subject.body).to eql({})
      end
    end
  end

  describe '#lsoa' do
    context 'when is success' do
      let(:body) { { result: { lsoa: 'FizzBuzz' } }.to_json }

      before do
        allow(stub_response).to receive(:success?).and_return(true)
      end

      it 'returns the lsoa as part of the result JSON' do
        expect(subject.lsoa).to eql('FizzBuzz')
      end
    end

    context 'when is not success' do
      before do
        allow(stub_response).to receive(:success?).and_return(false)
      end

      it 'returns nil' do
        expect(subject.lsoa).to be_nil
      end
    end
  end

  describe '#postcode' do
    context 'when is success' do
      let(:body) do
        { result: { postcode: 'FizzBuzz' } }.to_json
      end

      before do
        allow(stub_response).to receive(:success?).and_return(true)
      end

      it 'returns the postcode as part of the result JSON' do
        expect(subject.postcode).to eql('FizzBuzz')
      end
    end

    context 'when is not success' do
      before do
        allow(stub_response).to receive(:success?).and_return(false)
      end

      it 'returns nil' do
        expect(subject.postcode).to be_nil
      end
    end
  end

  describe '#error_message' do
    context 'when is success' do
      let(:body) do
        { error: "This won't be shown anyway" }.to_json
      end

      before do
        allow(stub_response).to receive(:success?).and_return(true)
      end

      it 'returns nil' do
        expect(subject.error_message).to be_nil
      end
    end

    context 'when is not success' do
      let(:body) do
        { error: 'Something gone rong!' }.to_json
      end

      before do
        allow(stub_response).to receive(:success?).and_return(false)
      end

      it 'returns the error node from the JSON body' do
        expect(subject.error_message).to eql('Something gone rong!')
      end
    end
  end
end
