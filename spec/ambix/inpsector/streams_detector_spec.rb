# frozen_string_literal: true

# rubocop:disable Layout/LineLength
describe Ambix::Inspector::StreamsDetector, :'ambix/inspector/streams_detector' do
  it { expect(described_class).to respond_to(:new).with_keywords(:shell) }

  context '#shell' do
    it { expect(subject.__send__(:shell)).to be_a(Ambix::Shell) }
  end

  it { expect(subject).to respond_to(:call).with(1).arguments }
end

sham!(:samples).info.each do |k, v|
  describe Ambix::Inspector::StreamsDetector, :'ambix/inspector/streams_detector', :call, k.to_sym do
    let(:subject) do
      sham!(:streams_detector).mocker.call(k)
    end

    context "#call(#{k.to_s.inspect})" do
      it { expect(subject.call(k)).to be_kind_of(Array) }
    end

    v.data.each_with_index do |track_data, index|
      context "#call(#{k.to_s.inspect}).fetch(#{index.inspect})" do
        it { expect(subject.call(k).fetch(index)).to be_a(Hash) }
      end

      context "#call(#{k.to_s.inspect}).fetch(#{index.inspect})" do
        it do
          expect(subject.call(k).fetch(index)).to eq(track_data.to_h)
        end
      end
    end
  end
end
# rubocop:enable Layout/LineLength
