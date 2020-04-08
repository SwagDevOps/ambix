# frozen_string_literal: true

autoload(:YAML, 'yaml')

# Return samples as a Hash with results indexed by name
info = lambda do
  {}.tap do |samples|
    # rubocop:disable Layout/LineLength
    SAMPLES_PATH.join('info').realpath.children.select(&:directory?).sort.each do |path|
      # @formatter:off
      samples[path.basename.to_s.to_sym] = {
        text: path.join('text.txt').read,
        data: path.join('data.yml')
                  .read.yield_self { |raw| YAML.safe_load(raw) }
      }.map { |k, v| [k, v.nil? ? {} : v] }.to_h.yield_self { |h| FactoryStruct.new(h) }
      # @formatter:off
    end
    # rubocop:enable Layout/LineLength
  end
end

Sham.config(FactoryStruct, File.basename(__FILE__, '.*').to_sym) do |c|
  c.attributes do
    # @formatter:off
    {
      info: info.call
    }
    # @formatter:on
  end
end
