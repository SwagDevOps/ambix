# frozen_string_literal: true

# rubocop:disable Layout/LineLength

register(:shell, memoize: true) { Ambix::Shell.new }
register(:streams_detector, memoize: true) { Ambix::Inspector::StreamsDetector.new }

# rubocop:enable Layout/LineLength
