$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ffi'

require 'libcbor/version'
require 'libcbor/inner/lib_cbor'
require 'libcbor/inner/lib_c'
require 'libcbor/cache'
require 'libcbor/tag'
require 'libcbor/simple_value'
require 'libcbor/byte_string'
require 'libcbor/helpers'
require 'libcbor/item'
require 'libcbor/streaming'
require 'libcbor/streaming/callback_simplifier'
require 'libcbor/streaming/buffered_decoder'
require 'libcbor/streaming/encoder'

# Provides encoding, decoding, and streaming interaction with CBOR data.
# Please refer to {file:README.md} for an overview and a short tutorial.
module CBOR
	# Thrown when the decoded data is either invalid or not well-formed
	class DecodingError < StandardError; end

	# Encodes the given object to CBOR representation
	# Custom semantics are supported - the object has to to provide the +to_cbor+ method
	# In case {CBOR.method_name} is not +to_cbor+, provide the custom method instead.
	#
	# @param [Integer, String, Float, Array, Map, Tag, TrueClass, FalseClass, NilClass, #to_cbor] object the object to encode
	# @return [String] the CBOR representation
	def self.encode(object)
		object.to_cbor
	end

	# The name of the method that is used for encoding objects. Defaults to +:to_cbor+
	#
	# @return [Symbol] the method name
	def self.method_name
		@@method_name
	end

	# Load the extensions for the core classes
	#
	# @param [Symbol] name the name to use for the encoding method. If not provided, +to_cbor+ will be used
	# @return [Array] list of the patched classes
	def self.load!(name = nil)
		@@method_name = name || :to_cbor
		%w{Integer Float Array Hash String TrueClass FalseClass NilClass Tag ByteString}.each do |klass|
			kklass = const_get(klass)
			kklass.send(:include, const_get('::CBOR::' + klass + 'Helper'))
			kklass.send(:alias_method, method_name, :__libcbor_to_cbor)
		end
	end

	# Deserialize CBOR
	#
	# @param [String] data
	# @return [Integer, String, Float, Array, Map, Tag, TrueClass, FalseClass, NilClass] resulting object
	# @raise [DecodingError] when presented with invalid data
	def self.decode(data)
		res = FFI::MemoryPointer.new LibCBOR::CborLoadResult
		Item.new(
			LibCBOR.cbor_load(FFI::MemoryPointer.from_string(data), data.bytes.count, res).
				tap { |ptr| raise DecodingError if ptr.null? }
		).value
	end
end



