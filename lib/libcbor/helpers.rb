module CBOR
	module Helpers
		class ::Fixnum
			def __to_cbor
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				if self >= 0
					@@bfr.get_bytes(0, LibCBOR.cbor_encode_uint(self, @@bfr, 9))
				else
					@@bfr.get_bytes(0, LibCBOR.cbor_encode_negint(-self - 1, @@bfr, 9))
				end
			end
		end

		class ::Float
			def __to_cbor
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				@@bfr.get_bytes(0, LibCBOR.cbor_encode_single(self, @@bfr, 9))
			end
		end

		class ::String
			def __to_cbor
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

		class ::Array
			def __to_cbor
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_array_start(count, @@bfr, 9))
				each do |member|
					header += member.__to_cbor
				end
				header
			end
		end

		class ::Hash
			def __to_cbor
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_map_start(count, @@bfr, 9))
				each do |member|
					header += member.first.__to_cbor
					header += member.last.__to_cbor
				end
				header
			end
		end

		class Tag
			def __to_cbor
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_map_start(count, @@bfr, 9))

			end
		end
	end
end
