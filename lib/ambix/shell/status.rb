# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../shell'

# Command execution status
#
# @see https://ruby-doc.org/core-2.3.0_preview1/Process/Status.html#method-i-exitstatus
class Ambix::Shell::Status
  # @return [String]
  attr_reader :stdout

  # @return [String]
  attr_reader :stderr

  # @param [Process::Status] status
  def initialize(status, **kwargs)
    self.status = status

    self.class.__send__(:filter_kwargs, **kwargs).each do |k, v|
      self.__send__("#{k}=", v)
    end
  end

  # rubocop:disable Layout/LineLength
  ::Process::Status.public_instance_methods.delete_if { |k| self.instance_methods.include?(k) }.each do |k|
    self.define_method(k) do |*args, &block|
      status.public_send(k, *args, &block)
    end
  end
  # rubocop:enable Layout/LineLength

  # @return [Boolean]
  def stdout?
    !stdout.nil?
  end

  # @return [Boolean]
  def stderr?
    !stderr.nil?
  end

  class << self
    # Create an instance from ``Open3.capture3()`` result.
    #
    # @param [String] stdout
    # @param [String] stderr
    # @param [Process::Status] status
    def from_open3(stdout, stderr, status)
      self.new(status, stdout: stdout, stderr: stderr)
    end

    protected

    # @api private
    #
    # @return [Hash{Symbol => Object}]
    def filter_kwargs(**kwargs)
      kwargs.keep_if { |k, _v| [:stderr, :stdout].include?(k) }
    end
  end

  protected

  attr_writer :stdout

  attr_writer :stderr

  # @return [Process::Status]
  attr_accessor :status
end
