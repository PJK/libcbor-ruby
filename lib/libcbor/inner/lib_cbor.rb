module CBOR
	module LibCBOR
		extend FFI::Library
		ffi_lib 'cbor'
		attach_function :cbor_decref, [:pointer], :void
		attach_function :cbor_serialize, [:pointer, :pointer, :size_t], :size_t
		attach_function :cbor_encode_uint, [:uint64, :pointer, :size_t], :size_t
		attach_function :cbor_encode_negint, [:uint64, :pointer, :size_t], :size_t
		attach_function :cbor_encode_single, [:float, :pointer, :size_t], :size_t
		attach_function :cbor_encode_array_start, [:size_t, :pointer, :size_t], :size_t
		attach_function :cbor_encode_map_start, [:size_t, :pointer, :size_t], :size_t
		# size_t cbor_serialize_alloc(const cbor_item_t * item, unsigned char ** buffer, size_t * buffer_size);
		attach_function :cbor_serialize_alloc, [:pointer, :pointer, :pointer], :size_t

		attach_function :cbor_new_definite_string, [], :pointer
		# void cbor_string_set_handle(cbor_item_t *item, unsigned char *data, size_t length);
		attach_function :cbor_string_set_handle, [:pointer, :pointer, :size_t], :void
	end
end