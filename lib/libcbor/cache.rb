module CBOR
	# Provides caching for simple values (true, false, nil)
	class Cache
		@@bfr = FFI::Buffer.new(:uchar, 1)

		def self.get_bool(val)
			@@bfr.get_bytes(0, LibCBOR.cbor_encode_bool(val, @@bfr, 1))
		end

		def self.get_null
			@@bfr.get_bytes(0, LibCBOR.cbor_encode_null(@@bfr, 1))
		end

		def self.true
			@@true ||= get_bool(true)
		end

		def self.false
			@@false ||= get_bool(false)
		end

		def self.nil
			@@null ||= get_null
		end
	end
end