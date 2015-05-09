require 'spec_helper'

module CBOR
	module Streaming
		describe BufferedDecoder do
			it 'Works' do
				data = "\x81\x2"
				LibCBOR.cbor_stream_decode(
					FFI::MemoryPointer.from_string(data) + 1,
					1,
					CallbackSimplifier.new(BufferedDecoder.new(integer: ->(x) { puts "got: #{x}"})).callback_set.to_ptr,
					nil
				)
			end
		end
	end
end