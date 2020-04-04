# frozen_string_literal: true

require 'ambix'

# testing ``Kamaze.project`` method
describe Ambix, :project do
  it { expect(described_class).to be_const_defined(:VERSION) }
end
