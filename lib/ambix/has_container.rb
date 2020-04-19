# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ambix'

# Define a container.
#
# @see https://dry-rb.org/gems/dry-container/0.8/
# @see https://dry-rb.org/gems/dry-auto_inject/0.6/
module Ambix::HasContainer
  protected

  # @return [Ambix:Container]
  def container
    @container ||= container_builder.call
  end

  # @return [Ambix:Container::Injector]
  def injector
    container.to_injector
  end

  # @return [Pathname]
  def container_config
    Pathname.new(__dir__).join('config', 'container.rb')
  end

  # @return [Proc]
  def container_builder
    lambda do
      Ambix::Container.new.tap do |c|
        c.instance_eval(container_config.read, container_config.to_s, 1)
      end
    end
  end
end
