$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'ffi'
require 'pry'


require 'libcbor/version'
require 'libcbor/inner/lib_cbor'
require 'libcbor/inner/lib_c'
require 'libcbor/helpers'

module CBOR
	class UndefinedConversion < StandardError; end

	def self.encode(obj)
		begin
			obj.__to_cbor
		rescue NoMethodError
			raise UndefinedConversion, "Objects of class #{obj.class} have no defined conversion to CBOR"
		end
	end
end



