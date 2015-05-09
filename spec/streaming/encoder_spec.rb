require 'spec_helper'

module CBOR
	module Streaming
		describe Encoder do
			let(:target) { StringIO.new }
			subject { Encoder.new(target) }

			it 'produces correct CBOR data' do
				subject.start_array
				subject << 1
				subject << 2
				subject.break

				expect(CBOR.decode(target.string)).to eq [1, 2]
			end
		end
	end
end