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

		attach_function :cbor_tag_value, [:cbor_item_t_ref], :uint64
		attach_function :cbor_tag_item, [:cbor_item_t_ref], :cbor_item_t_ref

		attach_function :cbor_float_ctrl_is_ctrl, [:cbor_item_t_ref], :bool
		attach_function :cbor_ctrl_value, [:cbor_item_t_ref], :uint8
		attach_function :cbor_float_get_float, [:cbor_item_t_ref], :double

		callback :cbor_int8_callback, [:pointer, :uint8], :void
		callback :cbor_int16_callback, [:pointer, :uint16], :void
		callback :cbor_int32_callback, [:pointer, :uint32], :void
		callback :cbor_int64_callback, [:pointer, :uint64], :void
		callback :cbor_simple_callback, [:pointer], :void
		callback :cbor_string_callback, [:pointer, :pointer, :size_t], :void
		callback :cbor_collection_callback, [:pointer, :size_t], :void
		callback :cbor_float_callback, [:pointer, :float], :void
		callback :cbor_double_callback, [:pointer, :double], :void
		callback :cbor_bool_callback, [:pointer, :bool], :void

		class CborCallbacks < FFI::Struct
			layout :uint8, :cbor_int8_callback,
				:uint16, :cbor_int16_callback,
				:uint32, :cbor_int32_callback,
				:uint64, :cbor_int64_callback,

				:negint8, :cbor_int8_callback,
				:negint16, :cbor_int16_callback,
				:negint32, :cbor_int32_callback,
				:negint64, :cbor_int64_callback,

				:byte_string, :cbor_string_callback,
				:byte_string_start, :cbor_simple_callback,

				:string, :cbor_string_callback,
				:string_start, :cbor_simple_callback,

				:array_start, :cbor_collection_callback,
				:indef_array_start, :cbor_simple_callback,

				:map_start, :cbor_collection_callback,
				:indef_map_start, :cbor_simple_callback,

				:tag, :cbor_int64_callback,

				:float2, :cbor_float_callback,
				:float4, :cbor_float_callback,
				:float8, :cbor_double_callback,

				:undefined, :cbor_simple_callback,
				:null, :cbor_simple_callback,
				:boolean, :cbor_bool_callback,

				:indef_break, :cbor_simple_callback
		end

		DecoderStatus = enum(:finished, :not_enough_data, :buffer_error, :error)

		class CborDecoderResult < FFI::Struct
			layout :read, :size_t,
				:status, DecoderStatus
		end

		# buffer, buffer size, callbacks, context
		attach_function :cbor_stream_decode, [:pointer, :size_t, :pointer, :pointer], CborDecoderResult.by_value

		attach_function :cbor_encode_tag, [:uint64, :memblock, :size_t], :size_t
	end
end