# frozen_string_literal: true

autoload(:Pathname, 'pathname')
autoload(:Singleton, 'singleton')

describe Ambix, :ambix do
  # @formatter:off
  [
    :Bundled,
    :Container,
    :HasContainer,
    :Injectable,
    :Inspector,
    :Shell,
    :VERSION,
  ].each do |k| # @formatter:on
    it { expect(described_class).to be_const_defined(k) }
  end
end

# class methods -----------------------------------------------------
describe Ambix, :ambix do
  # @formatter:off
  [
    :instance,
    :clear,
  ].each do |method| # @formatter:on
    it { expect(described_class).to respond_to(method).with(0).arguments }
  end

  # @formatter:off
  {
    instance: Ambix,
    clear: Class,
  }.each do |method, type| # @formatter:on
    context ".#{method}" do
      it { expect(described_class.__send__(method)).to be_a(type) }
    end
  end

  context '.clear' do
    it { expect(described_class.__send__(:clear)).to eq(described_class) }
  end

  context '.new' do
    NoMethodError.tap do |error_class|
      it "raises #{error_class}" do
        expect { Ambix.new }.to raise_error(error_class)
      end
    end
  end
end

# instance ----------------------------------------------------------
describe Ambix, :ambix do # rubocop:disable Metrics/BlockLength
  let(:subject) { described_class.instance }

  # noinspection RubyResolve
  # @formatter:off
  [
    Singleton,
    Ambix::HasContainer,
    Ambix::Bundled,
  ].each do |type|
    it { expect(subject).to be_a(type) }
  end
  # @formatter:on

  # @formatter:off
  [
    :container,
    :container_builder,
    :container_config,
    :injector
  ].each do |method| # @formatter:on
    context '#protected_methods' do
      it { expect(subject.protected_methods).to include(method) }
    end
  end

  # @formatter:off
  {
    container: Ambix::Container,
    container_builder: Proc,
    container_config: Pathname,
    injector: Ambix::Container::Injector,
  }.each do |method, type| # @formatter:on
    context "##{method}" do
      it { expect(subject.__send__(method)).to be_a(type) }
    end
  end
end

# container ---------------------------------------------------------
describe Ambix, :ambix, :container do
  let(:subject) { Ambix.__send__(:new) }

  # @formatter:off
  {
    shell: Ambix::Shell,
  }.each do |key, type| # @formatter:on
    context "#container[#{key}]" do
      it { expect(subject.__send__(:container)[key]).to be_a(type) }
    end
  end
end
