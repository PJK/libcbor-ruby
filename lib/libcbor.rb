$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ffi'

require 'libcbor/version'
require 'libcbor/inner/lib_cbor'
require 'libcbor/inner/lib_c'
require 'libcbor/cache'
require 'libcbor/tag'
require 'libcbor/helpers'
require 'libcbor/cbor_item'
require 'libcbor/streaming/callback_simplifier'
require 'libcbor/streaming/buffered_decoder'
require 'libcbor/streaming/encoder'

# Top level namespace
module CBOR
	# Thrown when the decoded data is either invalid or not well-formed
	class DecodingError < StandardError; end

	# Encodes the given object to CBOR representation
	# Custom semantics are supported - the object has to to provide the +to_cbor+ method
	# In case {CBOR.method_name} is not +to_cbor+, provide the custom method instead.
	#
	# @param [Fixnum, String, Float, Array, Map, Tag, #to_cbor] object the object to encode
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
	# @return nil
	def self.load!(name = nil)
		@@method_name = name
		%w{Fixnum Float Array Hash String TrueClass FalseClass NilClass Tag}.each do |klass|
			const_get(klass).send(:include, const_get('::CBOR::' + klass + 'Helper'))
		end
	end

	def self.decode(data)
		res = FFI::MemoryPointer.new LibCBOR::CborLoadResult
		CBORItem.new(
			LibCBOR.cbor_load(FFI::MemoryPointer.from_string(data), data.bytes.count, res).
				tap { |ptr| raise DecodingError if ptr.null? }
		).value
	end
end



