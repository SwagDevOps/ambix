# frozen_string_literal: true

describe Ambix, :ambix do
  # @formatter:off
  [
    :Inspector,
    :VERSION,
  ].each do |k|
    it { expect(described_class).to be_const_defined(k) }
  end
  # @formatter:on
end
