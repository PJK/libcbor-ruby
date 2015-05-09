module CBOR
	module Streaming
		class Encoder < Struct.new(:target)
			def <<(object)
				target.write(object.to_cbor)
			end

			def start_array
				target.write("\x9f")
			end

			def start_map
				target.write("\xbf")
			end

			def start_chunked_string
				target.write("\x9f")
			end

			def start_chunked_byte_string
				target.write("\x5f")
			end

			def tag(value)
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				@@bfr.get_bytes(0, LibCBOR.cbor_encode_tag(value, @@bfr, 9))
			end

			def break
				target.write("\xff")
			end
		end
	end
end