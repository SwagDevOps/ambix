# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ambix'
require 'dry/container'

# Container
#
# @see https://dry-rb.org/gems/dry-container/
# @see https://dry-rb.org/gems/dry-auto_inject/
class Ambix::Container < Dry::Container
  extend Dry::Container::Mixin

  autoload(:Injector, "#{__dir__}/container/injector")

  def register(key, contents = nil, options = {}, &block)
    if self.key?(key)
      Dry::Container.new.tap do |container|
        container.register(key, contents, options, &block)

        # noinspection RubyYardParamTypeMatch
        return self.merge(container)
      end
    end

    super
  end

  # @return [Injector]
  def to_injector
    Injector.new(self)
  end

  alias_method '[]=', 'register'
end
