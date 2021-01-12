# frozen_string_literal: true

RSpec.shared_context 'Postcode validating model' do
  it { is_expected.to validate_presence_of(:postcode) }

  it {
    is_expected.to allow_values("AA9A\s9AA", "A9A\s9AA", "A9\s9AA", "A99\s9AA", "AA9\s9AA", "AA99\s9AA").for(:postcode)
  }

  it {
    is_expected.to_not allow_values('XXXX', 'FOOBAR', '999', '9999', 'A99', 'A99').for(:postcode)
  }
end
