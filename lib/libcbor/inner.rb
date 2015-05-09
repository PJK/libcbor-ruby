require 'ffi'

module LibC
	ffi_lib FFI::Library::LIBC
	extend FFI::Library

	# memory allocators
	attach_function :malloc, [:size_t], :pointer
	attach_function :calloc, [:size_t], :pointer
	attach_function :valloc, [:size_t], :pointer
	attach_function :realloc, [:pointer, :size_t], :pointer
	attach_function :free, [:pointer], :void

	# memory movers
	attach_function :memcpy, [:pointer, :pointer, :size_t], :pointer
	attach_function :bcopy, [:pointer, :pointer, :size_t], :void

end # module LibC

module Libcbor
	extend FFI::Library
	ffi_lib 'cbor'
	attach_function :cbor_new_int8, [], :pointer
	attach_function :cbor_set_uint16, [:pointer, :ushort], :void
	attach_function :cbor_set_uint8, [:pointer, :uchar], :void
	attach_function :cbor_serialize, [:pointer, :pointer, :size_t], :size_t
	puts 'yo'
end