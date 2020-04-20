# frozen_string_literal: true

describe Ambix::Container, :'ambix/container' do
  # @formatter:off
  [
    :Injector,
  ].each do |k| # @formatter:on
    it { expect(described_class).to be_const_defined(k) }
  end

  context '.ancestors' do
    it { expect(described_class.ancestors).to include(Dry::Container, Dry::Container::Mixin) } # rubocop:disable Layout/LineLength
  end
end

# instance methods --------------------------------------------------
describe Ambix::Container, :'ambix/container' do
  it { expect(subject).to respond_to(:to_injector) }

  context '#to_injector' do
    it { expect(subject.to_injector).to be_a(Ambix::Container::Injector) }
  end
end
