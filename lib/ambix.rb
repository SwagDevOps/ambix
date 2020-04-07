# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

$LOAD_PATH.unshift(__dir__)

# Base module.
module Ambix
  # @formatter:off
  {
    Bundled: 'bundled',
    Inspector: 'inspector',
    VERSION: 'version',
  }.each { |s, fp| autoload(s, "#{__dir__}/ambix/#{fp}") }
  # @formatter:on

  include(Bundled).tap do
    require 'bundler/setup' if bundled?
    require 'kamaze/project/core_ext/pp' if development?
  end
end
