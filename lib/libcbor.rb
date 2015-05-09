$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ffi'
require 'pry'


require 'libcbor/version'
require 'libcbor/inner/lib_cbor'
require 'libcbor/inner/lib_c'
require 'libcbor/cache'
require 'libcbor/tag'
require 'libcbor/helpers'
require 'libcbor/cbor_item'

module CBOR
	class UndefinedConversion < StandardError; end

	def self.encode(obj)
		obj.to_cbor
	end

	def method_name
		@@method_name
	end

	def self.load!(name = nil)
		@@method_name = name
		%w{Fixnum Float Array Hash String TrueClass FalseClass NilClass Tag}.each do |klass|
			const_get(klass).send(:include, const_get('::CBOR::' + klass + 'Helper'))
		end
	end

	def self.load_native(data)
		res = FFI::MemoryPointer.new LibCBOR::CborLoadResult
		CBORItem.new(
			LibCBOR.cbor_load(FFI::MemoryPointer.from_string(data), data.bytes.count, res)
		)
	end

	def self.load(data)

	end
end



