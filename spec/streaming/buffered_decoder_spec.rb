require 'spec_helper'

module CBOR
	module Streaming
		describe BufferedDecoder do
			let(:counter) { double }
			let(:data) { "\x81\x2" }

			it 'works for nested data' do
				expect(counter).to receive(:tick).exactly(1)
				BufferedDecoder.new(
					integer: -> (val) { expect(val).to eq 2; counter.tick }
				) << data
			end
		end
	end
end