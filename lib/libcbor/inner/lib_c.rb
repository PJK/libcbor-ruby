# Provides native memory management
module CBOR::LibC
	extend FFI::Library
	ffi_lib FFI::Library::LIBC

	attach_function :malloc, [:size_t], :pointer
	attach_function :free, [:pointer], :void

	attach_function :memcpy, [:pointer, :pointer, :size_t], :pointer
	attach_function :bcopy, [:pointer, :pointer, :size_t], :void
end
