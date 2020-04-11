# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../inspector'

# Detect streams (tracks) in a multimedia file.
#
# Sample of use:
#
#
# ```ruby
# (StreamsDetector.new.call('input.avi')
#
# # [{:default=>true, :index=>"0:0", :language=>"und", :type=>"video"},
# # {:default=>true, :index=>"0:1", :language=>"fre", :type=>"audio"},
# # {:default=>false, :index=>"0:2", :language=>"eng", :type=>"audio"},
# # {:default=>false, :index=>"0:3", :language=>"fre", :type=>"subtitle"}]
# ````
class Ambix::Inspector::StreamsDetector
  autoload(:Open3, 'open3')

  def initialize
    @outputs = prepare_outputs(self)
  end

  # Detects streams/tracks from given filepath.
  #
  # @raise [Errno::ENOENT]
  # @return [Hash{Symbol => String|Boolan}]
  def call(file)
    outputs[file].map do |line|
      line.gsub(/\s*Stream\s+#/, '')
    end.map { |line| self.parse(line) }
  end

  protected

  # Cached outputs, indexed by filepath (as array of lines).
  #
  # @type [Hash{String => Array<String>}]
  attr_accessor :outputs

  # Get an Hash with ``#[]()`` method overriden as a lazy generator.
  #
  # @return [Hash]
  def prepare_outputs(container)
    {}.tap do |cache|
      cache.singleton_class.define_method(:[]) do |key|
        Pathname.new(key).realpath.to_s.tap do |fp|
          cache[fp] = container.__send__(:capture, fp) unless cache.key?(fp)
        end.yield_self do |fp|
          # noinspection RubyArgCount,RubySuperCallWithoutSuperclassInspection
          super(fp)
        end
      end
    end
  end

  # Capture result of ``ffmpeg -i`` command on given file.
  #
  # @return [Array<String>]
  def capture(file)
    # noinspection RubyResolve
    Open3.capture3('ffmpeg', '-i', file).fetch(1).lines.keep_if do |line|
      line =~ /^\s*Stream\s+#[0-9]/
    end.map(&:strip)
  end

  # Parse given line.
  #
  #
  # Sample lines:
  #
  # ```ruby
  # ["0:0: Video: h264 (High), yuv420p(progressive), 25 fps, 25 tbr (default)",
  # "0:1(fre): Audio: aac (LC), 44100 Hz, stereo, fltp (default)",
  # "0:2(eng): Audio: aac (LC), 44100 Hz, stereo, fltp",
  # "0:3(fre): Subtitle: subrip"]
  # ````
  #
  # @return [Hash{Symbol => String}>]
  def parse(line) # rubocop:disable Metrics/AbcSize
    # rubocop:disable Layout/LineLength
    # @formatter:off
    {
      index: -> { line.match(/^([0-9]+:[0-9]+)(\([a-z]{3}\))?:/).captures.fetch(0) },
      language: -> { (line.match(/^([0-9]+:[0-9]+)(\([a-z]{3}\))?:/).captures.fetch(1) || '(und)').gsub(/^\(|\)$/, '') },
      type: -> { line.split(/\s+/).fetch(1).gsub(/:$/, '').downcase },
      default: -> { line.split(/\s+/).include?('(default)') },
      forced: -> { line.split(/\s+/).include?('(forced)') },
    }.map { |k, v| [k, v.call.freeze] }.sort.to_h
    # @formatter:on
    # rubocop:enable Layout/LineLength
  end
end
