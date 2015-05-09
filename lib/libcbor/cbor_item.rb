module CBOR
	# Wraps native `cbor_item_t *`
	class CBORItem < Struct.new(:handle)
		def type
			LibCBOR.cbor_typeof(handle)
		end

		def value
			case type
				when :uint
					LibCBOR.cbor_get_int(handle)
				when :negint
					-LibCBOR.cbor_get_int(handle) - 1
				when :string
					LibCBOR
						.cbor_string_handle(handle)
						.get_string(0, LibCBOR.cbor_string_length(handle))
				else
					raise 'Unknown type - the FFI enum mapping is probably broken. Please report this bug.'
			end
		end
	end
end