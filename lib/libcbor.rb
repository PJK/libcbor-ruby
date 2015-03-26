require './libcbor/version'
require 'ffi'


module LibC
  extend FFI::Library
  ffi_lib FFI::Library::LIBC
  
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
	ffi_lib ['/usr/local/lib/libcbor.so']
	attach_function :cbor_new_int8, [], :pointer
	attach_function :cbor_set_uint16, [:pointer, :ushort], :void
	attach_function :cbor_set_uint8, [:pointer, :uchar], :void
	attach_function :cbor_serialize, [:pointer, :pointer, :size_t], :size_t
	puts 'yo'
end


puts (x = Libcbor.cbor_new_int8).inspect

puts Libcbor.cbor_set_uint8(x, 55).inspect

buffer = LibC.malloc 512

puts Libcbor.cbor_serialize(x, buffer, 512)
y = Libcbor.cbor_new_int8
puts buffer
puts buffer.read_string.inspect

require 'cbor'
require 'benchmark/ips'

Benchmark.ips do |x|
  # Configure the number of seconds used during
  # the warmup phase (default 2) and calculation phase (default 5)
  x.config(:time => 3, :warmup => 1)
  x.report("lib") { 55.to_cbor }
  x.report('cb') {
	Libcbor.cbor_set_uint8(y, 55).inspect
	#Libcbor.cbor_serialize(y, buffer, 512) 
  }
 end

