# frozen_string_literal: true

autoload(:Pathname, 'pathname')
autoload(:Singleton, 'singleton')
require 'dry/auto_inject'
require 'dry/container'

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
    container: Dry::Container,
    container_builder: Proc,
    container_config: Pathname,
    injector: Dry::AutoInject::Builder,
  }.each do |method, type| # @formatter:on
    context "##{method}" do
      it { expect(subject.__send__(method)).to be_a(type) }
    end
  end
end
