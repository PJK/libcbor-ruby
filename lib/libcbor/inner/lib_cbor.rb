module CBOR
	module LibCBOR
		extend FFI::Library
		ffi_lib 'cbor'

		CborItemTRef = typedef :pointer, :cbor_item_t_ref
		typedef :pointer, :cbor_item_t_ref_array
		typedef :pointer, :buffer
		typedef :pointer, :memblock # unsigned char * - string & bytestring handles, raw blocks

		ErrorCode = enum(:none, :notenoughdata, :nodata, :malformated, :memerror, :syntaxerror)

		class CborError < FFI::Struct
			layout :position, :size_t,
				:code, ErrorCode
		end

		class CborLoadResult < FFI::Struct
			layout :error, CborError,
				:read, :size_t
		end

		class CborPair < FFI::Struct
			layout :key, CborItemTRef,
				:value, CborItemTRef
		end

		typedef :pointer, :cbor_pair_array

		typedef :pointer, :cbor_load_result_ref

		attach_function :cbor_decref, [:pointer], :void
		attach_function :cbor_serialize, [:pointer, :pointer, :size_t], :size_t
		attach_function :cbor_encode_uint, [:uint64, :pointer, :size_t], :size_t
		attach_function :cbor_encode_negint, [:uint64, :pointer, :size_t], :size_t
		attach_function :cbor_encode_single, [:float, :pointer, :size_t], :size_t
		attach_function :cbor_encode_array_start, [:size_t, :pointer, :size_t], :size_t
		attach_function :cbor_encode_map_start, [:size_t, :pointer, :size_t], :size_t
		attach_function :cbor_encode_tag, [:uint64, :pointer, :size_t], :size_t
		attach_function :cbor_encode_bool, [:bool, :pointer, :size_t], :size_t
		attach_function :cbor_encode_null, [:pointer, :size_t], :size_t
		attach_function :cbor_encode_undef, [:pointer, :size_t], :size_t
		# size_t cbor_serialize_alloc(const cbor_item_t * item, unsigned char ** buffer, size_t * buffer_size);
		attach_function :cbor_serialize_alloc, [:pointer, :pointer, :pointer], :size_t

		attach_function :cbor_new_definite_string, [], :pointer
		# void cbor_string_set_handle(cbor_item_t *item, unsigned char *data, size_t length);
		attach_function :cbor_string_set_handle, [:pointer, :pointer, :size_t], :void

		Type = enum(:uint, :negint, :bytestring, :string, :array, :map, :tag, :float_ctrl)

		attach_function :cbor_typeof, [:cbor_item_t_ref], Type
		attach_function :cbor_load, [:buffer, :size_t, :cbor_load_result_ref], :cbor_item_t_ref

		attach_function :cbor_get_int, [:cbor_item_t_ref], :uint64

		attach_function :cbor_string_length, [:cbor_item_t_ref], :size_t
		attach_function :cbor_string_handle, [:cbor_item_t_ref], :memblock

		attach_function :cbor_bytestring_length, [:cbor_item_t_ref], :size_t
		attach_function :cbor_bytestring_handle, [:cbor_item_t_ref], :memblock

		attach_function :cbor_array_size, [:cbor_item_t_ref], :size_t
		attach_function :cbor_array_handle, [:cbor_item_t_ref], :cbor_item_t_ref_array

		attach_function :cbor_map_size, [:cbor_item_t_ref], :size_t
		attach_function :cbor_map_handle, [:cbor_item_t_ref], :cbor_pair_array

		attach_function :cbor_float_ctrl_is_ctrl, [:cbor_item_t_ref], :bool
		attach_function :cbor_ctrl_value, [:cbor_item_t_ref], :uint8
		attach_function :cbor_float_get_float, [:cbor_item_t_ref], :double
	end
end