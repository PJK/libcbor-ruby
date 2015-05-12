module CBOR
	# Wraps native +cbor_item_t *+ to allow extracting Ruby objects
	#
	# Takes responsibility for high-level native interfacing and object
	# lifetime management.
	#
	# @attr [FFI::Pointer] handle Native memory handle
	class Item < Struct.new(:handle)
		# Type of the underlying item
		#
		# @return [Symbol] one of {LibCBOR::Type}
		def type
			LibCBOR.cbor_typeof(handle)
		end

		# Ruby representation of the {Item}
		#
		# Arrays and hash maps are constructed recursively
		#
		# @return [Fixnum, String, Float, Array, Map, Tag, TrueClass, FalseClass, NilClass] Value extracted from the {#handle}
		def value
			case type
				when :uint
					LibCBOR.cbor_get_int(handle)
				when :negint
					-LibCBOR.cbor_get_int(handle) - 1
				when :string
					load_string
				when :bytestring
					load_bytestring
				when :array
					LibCBOR
						.cbor_array_handle(handle)
						.read_array_of_type(LibCBOR::CborItemTRef, :read_pointer, LibCBOR.cbor_array_size(handle))
						.map { |item| Item.new(item).value }
				when :map
					pairs_handle = LibCBOR.cbor_map_handle(handle)
					Hash[LibCBOR.cbor_map_size(handle).times.map { |idx|
						pair = LibCBOR::CborPair.new(pairs_handle + LibCBOR::CborPair.size * idx)
						[pair[:key], pair[:value]].map { |ptr| Item.new(ptr).value }
					}]
				when :tag
					Tag.new(
						LibCBOR.cbor_tag_value(handle),
						Item.new(LibCBOR.cbor_tag_item(handle)).value
					)
				when :float_ctrl
					load_float
				else
					raise 'Unknown type - the FFI enum mapping is probably broken. Please report this bug.'
			end
		end

		protected

		# Loads float, doesn't check the type
		#
		# @return [Float] the result
		def load_float
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
		end

		# Loads string, doesn't check the type
		#
		# If the underlying string is indefinite, the concatenation of its chunks is returned
		#
		# @return [String] the result
		def load_string
			if LibCBOR.cbor_string_is_definite(handle)
				LibCBOR
					.cbor_string_handle(handle)
					.get_string(0, LibCBOR.cbor_string_length(handle))
			else
				LibCBOR
					.cbor_string_chunks_handle(handle)
					.read_array_of_type(LibCBOR::CborItemTRef, :read_pointer, LibCBOR.cbor_string_chunk_count(handle))
					.map { |item| Item.new(item).value }
					.join
				end
		end

		# Loads byte string, doesn't check the type
		#
		# If the underlying string is indefinite, the concatenation of its chunks is returned
		#
		# @return [String] the result
		def load_bytestring
			# TODO: DRY - load_string
			if LibCBOR.cbor_bytestring_is_definite(handle)
				ByteString.new(
					LibCBOR
						.cbor_bytestring_handle(handle)
						.get_string(0, LibCBOR.cbor_bytestring_length(handle))
				)
			else
				ByteString.new(
					LibCBOR
						.cbor_bytestring_chunks_handle(handle)
						.read_array_of_type(LibCBOR::CborItemTRef, :read_pointer, LibCBOR.cbor_bytestring_chunk_count(handle))
						.map { |item| Item.new(item).value }
						.join
				)
			end
		end
	end
end