# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ambix'

# Shell abstraction
class Ambix::Shell
  autoload(:Open3, 'open3')

  def initialize(env = {})
    @env = default_env.merge(env.clone.to_h).freeze
  end

  # Captures the standard output and the standard error of a command.
  #
  # @return [Struct]
  def capture(*args)
    # noinspection RubyResolve
    Open3.capture3(*[self.env].concat(args)).tap do |results|
      Struct.new(:stdout, :stderr, :status).tap do |s|
        return s.new(*results)
      end
    end
  end

  protected

  attr_accessor :env

  def default_env
    # @formatter:off
    {
      'LANG' => 'en_US.%<charset>s' % {
        charset: ENV.fetch('LANG', 'en_US.UTF-8').split('.').fetch(1, 'UTF-8')
      }
    }
    # @formatter:off
  end
end
