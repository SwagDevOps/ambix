# frozen_string_literal: true

describe Ambix::Inspector, :'ambix/inspector' do
  # @formatter:off
  [
    :StreamsDetector,
    :Track,
  ].each do |k|
    it { expect(described_class).to be_const_defined(k) }
  end
  # @formatter:on
end

# execute: rake test[ambix/inspector,multi_en_fr]
[:tracks_for, :streams_for].each do |method| # rubocop:disable Metrics/BlockLength
  sham!(:samples).info.each do |k, v| # rubocop:disable Metrics/BlockLength
    describe Ambix::Inspector, :'ambix/inspector', :"##{method}", k.to_sym do
      let(:subject) do
        sham!(:streams_detector).mocker.call(k).yield_self do |streams_detector|
          described_class.new(streams_detector: streams_detector)
        end
      end

      context "##{method}(#{k.to_s.inspect})" do
        it { expect(subject.public_send(method, k)).to be_kind_of(Array) }
      end

      v.data.each_with_index do |track_data, index|
        context "##{method}(#{k.to_s.inspect}).fetch(#{index.inspect})" do
          it do
            subject.public_send(method, k).fetch(index).tap do |track|
              expect(track).to be_a(Ambix::Inspector::Track)
            end
          end
        end

        context "##{method}(#{k.to_s.inspect}).fetch(#{index.inspect}).to_h" do
          it do
            subject.public_send(method, k).fetch(index).to_h.tap do |data|
              expect(data).to eq(track_data.to_h)
            end
          end
        end
      end
    end
  end
end
