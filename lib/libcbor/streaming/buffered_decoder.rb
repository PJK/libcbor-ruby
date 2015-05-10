module CBOR
	module Streaming
		# Decodes a stream of data and invokes the appropriate callbacks
		#
		# TODO doc them
		class BufferedDecoder
			def initialize(callbacks = {})
				@callbacks = {
					integer: Proc.new {},
					string: Proc.new {},
					chunked_string_start: Proc.new {},
					byte_string: Proc.new {},
					chunked_byte_string_start: Proc.new {},
					float: Proc.new {},
					definite_array: Proc.new {},
					array_start: Proc.new {},
					definite_map: Proc.new {},
					map_start: Proc.new {},
					tag: Proc.new {},
					bool: Proc.new {},
					null: Proc.new {},
					simple: Proc.new {},
					break: Proc.new {},
				}.merge(callbacks)
				@buffer = ''
				@proxy = CallbackSimplifier.new(self)
			end

			def <<(data)
				@buffer += data
				loop do
					read = LibCBOR.cbor_stream_decode(
						FFI::MemoryPointer.from_string(@buffer),
						@buffer.bytes.length,
						@proxy.callback_set.to_ptr,
						nil
					)[:read]
					break if read == 0
					@buffer = @buffer[read .. -1]
				end
			end

			def callback(name, *args)
				callbacks[name].call(*args)
			end

			attr_reader :buffer

			protected

			attr_reader :callbacks
		end
	end
end