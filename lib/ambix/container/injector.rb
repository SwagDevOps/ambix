# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../container'
require 'dry/auto_inject'

# Injector
#
# Intended to easify tests (by providing ``kind_of?`` method):
#
# ```ruby
# it { expect(subject.__send__(:injector)).to be_a(Dry::AutoInject::Builder) }
# ```
#
# @see https://dry-rb.org/gems/dry-auto_inject/
# @see Ambix::Container#to_injector
class Ambix::Container::Injector < Dry::AutoInject::Builder
  # @!method class
  #   Returns the class of obj.
  #   This method must always be called with an explicit receiver,
  #   as class is also a reserved word in Ruby.
  #
  #   @return [Class]
  #   @see https://ruby-doc.org/core-2.7.1/Object.html#method-i-class
  self.tap do |klass|
    class_eval <<-METHOD, __FILE__, __LINE__ + 1
      def class
        ::#{klass}
      end
    METHOD
  end

  # @param [Class] klass
  # @return [Boolean]
  #
  # @see https://apidock.com/ruby/Object/kind_of%3F
  # @see https://ruby-doc.org/core-2.7.1/Object.html#method-i-kind_of-3F
  def kind_of?(klass)
    self.class.ancestors.include?(klass)
  end
end
