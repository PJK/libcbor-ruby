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
				when :bytestring
					LibCBOR
						.cbor_bytestring_handle(handle)
						.get_string(0, LibCBOR.cbor_bytestring_length(handle))
				when :array
					LibCBOR
						.cbor_array_handle(handle)
						.read_array_of_type(LibCBOR::CborItemTRef, :read_pointer, LibCBOR.cbor_array_size(handle))
						.map { |item| CBORItem.new(item).value }
				when :map
					pairs_handle = LibCBOR.cbor_map_handle(handle)
					Hash[LibCBOR.cbor_map_size(handle).times.map { |idx|
						pair = LibCBOR::CborPair.new(pairs_handle + LibCBOR::CborPair.size * idx)
						[pair[:key], pair[:value]].map { |ptr| CBORItem.new(ptr).value }
					}]
				when :tag
					Tag.new(
						LibCBOR.cbor_tag_value(handle),
						CBORItem.new(LibCBOR.cbor_tag_item(handle)).value
					)
				when :float_ctrl
					if LibCBOR.cbor_float_ctrl_is_ctrl(handle)
						case ctr_val = LibCBOR.cbor_ctrl_value(handle)
							when 20
								false
							when 21
								true
							when 22
								nil
							else
								ctr_val
						end
					else
						LibCBOR.cbor_float_get_float(handle)
					end
				else
					raise 'Unknown type - the FFI enum mapping is probably broken. Please report this bug.'
			end
		end
	end
end