module CBOR
	module FixnumHelper
		def to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			if self >= 0
				@@bfr.get_bytes(0, LibCBOR.cbor_encode_uint(self, @@bfr, 9))
			else
				@@bfr.get_bytes(0, LibCBOR.cbor_encode_negint(-self - 1, @@bfr, 9))
			end
		end
	end

	module FloatHelper
		def to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			@@bfr.get_bytes(0, LibCBOR.cbor_encode_single(self, @@bfr, 9))
		end
	end

	module StringHelper
		def to_cbor
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

	module ArrayHelper
		def to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_array_start(count, @@bfr, 9))
			each do |member|
				header += member.to_cbor
			end
			header
		end
	end

	module HashHelper
		def to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_map_start(count, @@bfr, 9))
			each do |member|
				header += member.first.to_cbor
				header += member.last.to_cbor
			end
			header
		end
	end

	module TagHelper
		def to_cbor
			@@bfr ||= FFI::Buffer.new(:uchar, 9)
			header = @@bfr.get_bytes(0, LibCBOR.cbor_encode_tag(value, @@bfr, 9))
			header + item.to_cbor
		end
	end

	module TrueClassHelper
		def to_cbor
			Cache.true
		end
	end

	module FalseClassHelper
		def to_cbor
			Cache.false
		end
	end

	module NilClassHelper
		def to_cbor
			Cache.nil
		end
	end
end
