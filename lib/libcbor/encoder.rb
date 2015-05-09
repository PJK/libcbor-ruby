module CBOR
	class Encoder
		def self.encode(object)

		end

		def self.encode_fixnum(fixnum)
			@@bfr_9 ||= FFI::Buffer.new(:uchar, 9)
			if fixnum >= 0
				@@bfr_9.get_bytes(0, LibCBOR.cbor_encode_uint(fixnum, @@bfr, 9))
			else
				@@bfr_9.get_bytes(0, LibCBOR.cbor_encode_negint(-fixnum - 1, @@bfr, 9))
			end
		end
	end
end