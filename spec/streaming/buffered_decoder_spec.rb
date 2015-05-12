require 'spec_helper'

module CBOR
	module Streaming
		describe BufferedDecoder do
			let(:counter) { double }
			let(:data) { "\x81\x2\x60\x40" }

			it 'decodes nested data' do
				expect(counter).to receive(:tick).exactly(1)
				BufferedDecoder.new(
					integer: -> (val) { expect(val).to eq 2; counter.tick }
				) << data
			end

			it 'raises for invalid input' do
				expect {
					BufferedDecoder.new << "\x1F" # Reserved
				}.to raise_exception DecodingError
			end
		end
	end
end