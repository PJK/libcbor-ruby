module CBOR
	# Provides caching for simple values (true, false, nil)
	class Cache
		@@bfr = FFI::Buffer.new(:uchar, 1)

		# Returns encoded equivalent
		#
		# @param [Bool] +true+ or +false+
		# @return [String] The CBOR equivalent
		def self.get_bool(val)
			@@bfr.get_bytes(0, LibCBOR.cbor_encode_bool(val, @@bfr, 1))
		end

		# Returns encoded null (+nil+) equivalent
		#
		# @return [String] The CBOR equivalent
		def self.get_null
			@@bfr.get_bytes(0, LibCBOR.cbor_encode_null(@@bfr, 1))
		end

		# Returns cached encoded +true+ equivalent
		#
		# @return [String] The CBOR equivalent
		def self.true
			@@true ||= get_bool(true)
		end

		# Returns cached encoded +false+ equivalent
		#
		# @return [String] The CBOR equivalent
		def self.false
			@@false ||= get_bool(false)
		end

		# Returns cached encoded +nil+ equivalent
		#
		# @return [String] The CBOR equivalent
		def self.nil
			@@null ||= get_null
		end
	end
end