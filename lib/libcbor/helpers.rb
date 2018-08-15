module CBOR
	# Provides the {#to_cbor} (or equivalent) method for Integers
	module IntegerHelper
		# Encodes Integers. Width and signedness are handled automatically.
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			if self >= 0
				@@bfr.get_bytes(0, LibCBOR.cbor_encode_uint(self, @@bfr, 9))
			else
				@@bfr.get_bytes(0, LibCBOR.cbor_encode_negint(-self - 1, @@bfr, 9))
			end
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for Floats
	module FloatHelper
		# Encodes Floatss. Width and precision are handled automatically
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			@@bfr.get_bytes(0, LibCBOR.cbor_encode_single(self, @@bfr, 9))
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for Stringss
	module StringHelper
		# Encodes Strings. The result is always a definite string.
		#
		# The string is assumed to be a valid UTF-8 string. The precondition
		# is not verified.
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@item ||= LibCBOR.cbor_new_definite_string
			string = FFI::MemoryPointer.from_string(self)
			out_bfr = FFI::MemoryPointer.new :pointer
			out_bfr_len = FFI::MemoryPointer.new :size_t
			LibCBOR.cbor_string_set_handle(@@item, string, bytes.length)
			res_len = LibCBOR.cbor_serialize_alloc(@@item, out_bfr, out_bfr_len)
			out_bfr.read_pointer.get_bytes(0, res_len).tap do
				LibC.free(out_bfr.read_pointer)
			end
		end
	end


	module ByteStringHelper
		# Encodes {ByteString}s. The result is always a definite string.
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@item ||= LibCBOR.cbor_new_definite_bytestring
			string = FFI::MemoryPointer.from_string(self)
			out_bfr = FFI::MemoryPointer.new :pointer
			out_bfr_len = FFI::MemoryPointer.new :size_t
			LibCBOR.cbor_bytestring_set_handle(@@item, string, bytes.length)
			res_len = LibCBOR.cbor_serialize_alloc(@@item, out_bfr, out_bfr_len)
			out_bfr.read_pointer.get_bytes(0, res_len).tap do
				LibC.free(out_bfr.read_pointer)
			end
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for Arrayss
	module ArrayHelper
		# Encodes Arrayss. The resulting item is always a definite array.
		#
		# The members are encoded recursively using the +to_cbor+ method or its equivalent
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_array_start(count, @@bfr, 9))
			each do |member|
				header += member.public_send(CBOR.method_name)
			end
			header
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for Hashes
	module HashHelper
		# Encodes Hashes. The resulting item is always a definite map.
		#
		# The members are encoded recursively using the +to_cbor+ method or its equivalent
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_map_start(count, @@bfr, 9))
			each do |member|
				header += member.first.public_send(CBOR.method_name)
				header += member.last.public_send(CBOR.method_name)
			end
			header
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for Tags
	module TagHelper
		# Encodes Tags.
		#
		# The {Tag#item} is encoded recursively using the +to_cbor+ method or its equivalent
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_tag(value, @@bfr, 9))
			header + item.public_send(CBOR.method_name)
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for +true+
	module TrueClassHelper
		# Encodes +true+s.
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			Cache.true
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for +false+
	module FalseClassHelper
		# Encodes +false+s.
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			Cache.false
		end
	end

	# Provides the {#to_cbor} (or equivalent) method for +nil+
	module NilClassHelper
		# Encodes +nil+s.
		#
		# @return [String] The CBOR representation
		def __libcbor_to_cbor
			Cache.nil
		end
	end
end
