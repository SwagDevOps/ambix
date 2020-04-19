# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ambix'
require 'kamaze/version'

class Ambix
  # @see https://github.com/SwagDevOps/kamaze-version
  VERSION = Kamaze::Version.new.freeze
end
