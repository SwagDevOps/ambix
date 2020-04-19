# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

autoload(:Singleton, 'singleton')
autoload(:Pathname, 'pathname')

# Base module.
class Ambix
  # noinspection RubyResolve
  include Singleton

  # @formatter:off
  {
    Bundled: 'bundled',
    Container: 'container',
    HasContainer: 'has_container',
    Injectable: 'injectable',
    Inspector: 'inspector',
    Shell: 'shell',
    VERSION: 'version',
  }.each { |s, fp| autoload(s, "#{__dir__}/ambix/#{fp}") }
  # @formatter:on

  include(Bundled).tap do
    require 'bundler/setup' if bundled?
    require 'kamaze/project/core_ext/pp' if development?
  end

  include(HasContainer)

  class << self
    # Clear singleton instance.
    #
    # @see https://github.com/JuanitoFatas/ruby-2.2.2-standard-library/blob/master/singleton.rb
    def clear
      self.tap do
        @singleton__mutex__.synchronize { @singleton__instance__ = nil }
      end
    end
  end
end
