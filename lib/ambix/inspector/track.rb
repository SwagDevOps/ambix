# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../inspector'

# Inspect given file.
class Ambix::Inspector::Track
  # @return [String]
  attr_reader :language

  # @return [String]
  attr_reader :type

  def initialize(**kwargs)
    kwargs.each do |k, v|
      next unless respond_to?("#{k}=", true)

      self.__send__("#{k}=", v)
    end
  end

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
    !!@default
  end

  # @return [Boolean]
  def forced?
    !!@forced
  end

  # @return [String]
  def index
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

  # @return [Hash<Symbol => String|Boolean>]
  def to_h
    [:index, :language, :type, :default].sort.map do |k|
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

  # @param [Boolean] default
  def default=(default)
    @default = !!default
  end

  def forced=(forced)
    @forced = !!forced
  end
end
