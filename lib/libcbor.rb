$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ffi'
require 'pry'


require 'libcbor/version'
require 'libcbor/inner/lib_cbor'
require 'libcbor/inner/lib_c'
require 'libcbor/cache'
require 'libcbor/encoder'
require 'libcbor/tag'
require 'libcbor/helpers'

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
end



