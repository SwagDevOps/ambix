# frozen_string_literal: true

describe Ambix::Inspector, :'ambix/inspector' do
  # @formatter:off
  [
    :StreamsDetector,
    :Track,
  ].each do |k|
    it { expect(described_class).to be_const_defined(k) }
  end
  # @formatter:on
end
