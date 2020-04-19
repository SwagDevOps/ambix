# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../ambix'

# Inspect given file.
class Ambix::Inspector
  # @formatter:off
  {
    StreamsDetector: 'streams_detector',
    Track: 'track'
  }.each { |s, fp| autoload(s, "#{__dir__}/inspector/#{fp}") }
  # @formatter:on

  include(Ambix::Injectable)
  inject(:streams_detector)

  # @param [String] file
  #
  #
  def streams_for(file)
    streams_detector.call(file).map { |h| Track.new(**h) }
  end

  alias tracks_for streams_for

  protected

  # @return [StreamsDetector]
  attr_reader :streams_detector
end
