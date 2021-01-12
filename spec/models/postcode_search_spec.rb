# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostcodeSearch, type: :model do
  context 'validations' do
    include_context 'Postcode validating model'
  end
end
