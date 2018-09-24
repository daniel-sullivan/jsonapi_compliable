require 'spec_helper'

RSpec.describe JsonapiCompliable::Stats::Payload do
  let(:dsl)      { double }
  let(:query)    { { stats: { attr1: [:count, :average], attr2: [:maximum] } } }
  let(:scope)    { double.as_null_object }
  let(:instance) { described_class.new(dsl, query, scope) }

  describe '#generate' do
    subject { instance.generate }

    def stub_stat(attr, calc, result, with_resource=false)
      if with_resource
        allow(dsl).to receive(:stat).with(attr, calc) { ->(_,_,_) { result } }
      else
        allow(dsl).to receive(:stat).with(attr, calc) { ->(_,_) { result } }
      end
    end

    before do
      stub_stat(:attr1, :count, 2)
      stub_stat(:attr1, :average, 1)
      stub_stat(:attr2, :maximum, 3)
      stub_stat(:attr3, :maximum, 3, true)
    end

    it 'generates the correct payload for each requested stat' do
      expect(subject).to eq({
        attr1: { count: 2, average: 1 },
        attr2: { maximum: 3 }
      })
    end
  end
end
