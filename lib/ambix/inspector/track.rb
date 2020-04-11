# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../inspector'

# Describe a track (or stream given ffmpeg vocable).
class Ambix::Inspector::Track
  # @return [String]
  attr_reader :language

  # @return [String]
  attr_reader :type

  class << self
    # Defaults used with kwargs.
    #
    # @return [Hash{Symbol => Object}]
    #
    # @see Track#initialize
    def defaults(**kwargs)
      # @formatter:off
      {
        index: nil,
        language: nil,
        type: nil,
        default: false,
        forced: false,
      }.sort.to_h.tap do |defaults|
        kwargs.each { |k, v| defaults[k] = v if defaults.key?(k) }
      end
      # @formatter:on
    end
  end

  # rubocop:disable Layout/LineLength

  # @option kwargs [String] :index
  # @option kwargs [String] :language
  # @option kwargs [String] :type for example ``video``, ``audio`` or ``subtitle``
  # @option kwargs [Boolean] :default
  # @option kwargs [Boolean] :forced
  def initialize(**kwargs)
    self.class.defaults(**kwargs).each { |k, v| self.__send__("#{k}=", v) }
  end

  # rubocop:enable Layout/LineLength

  class Error < ::StandardError
  end

  # Describe an index format error.
  #
  #
  # @see Track#index
  class IndexFormatError < Error
    def initialize(index)
      @index = index
    end

    def message
      "Can not cast #{@index.inspect} to integer"
    end
  end

  # @return [Boolean]
  def default?
    !!self.default
  end

  # @return [Boolean]
  def forced?
    !!self.forced
  end

  # @return [String]
  def index
    return @index unless @index.is_a?(String)

    @index.dup.yield_self do |index|
      index.singleton_class.define_method(:to_i) do
        index.match(/^[0-9]+:([0-9]+)$/).captures.fetch(0).yield_self do |v|
          raise IndexFormatError, index if v.nil?

          v.to_i
        end
      end

      index.freeze
    end
  end

  # @return [Hash<Symbol => String|Boolean|Object>]
  def to_h
    self.class.defaults.keys.sort.map do |k|
      [k, self.__send__(k).freeze]
    end.to_h
  end

  protected

  # @type [String]
  attr_writer :index

  # @type [String]
  attr_writer :language

  # @type [String]
  attr_writer :type

  # @type [Boolean]
  attr_reader :default

  # @type [Boolean]
  attr_reader :forced

  # @param [Boolean] default
  def default=(default)
    @default = !!default
  end

  def forced=(forced)
    @forced = !!forced
  end
end
