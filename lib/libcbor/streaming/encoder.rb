module CBOR
	module Streaming
		# Provides streaming encoding facilities. Initialize it with an output
		# object and either feed it encodable objects, or invoke the methods
		# directly
		class Encoder
			# @param [StringIO, Socket, File, #write] stream Output object. Must support
			#		+write+ method that takes a +String+ as a parametr
			def initialize(stream)
				@stream = stream
			end

			# Serializes and writes an object to the stream
			#
			# @param [#to_cbor] object Object to serialize and write
			# @return [void]
			def <<(object)
				stream.write(object.public_send(CBOR.method_name))
			end

			# Encodes a 'start array' mark. You are responsible for
			# correctly {#break}ing it
			#
			# @return [void]
			def start_array
				stream.write("\x9f")
			end

			# Encodes a 'start map' mark. You are responsible for
			# correctly {#break}ing it
			#
			# @return [void]
			def start_map
				stream.write("\xbf")
			end

			# Encodes a 'start indefinite string' mark. You are responsible
			# for correctly {#break}ing it
			#
			# @return [void]
			def start_chunked_string
				stream.write("\x7f")
			end

			# Encodes a 'start indefinite byte string' mark. You are responsible
			# for correctly {#break}ing it
			#
			# @return [void]
			def start_chunked_byte_string
				stream.write("\x5f")
			end

			# Encodes a tag with the give +value+.
			#
			# You are responsible for correctly supplying the item that
			# follows (i.e. the one the tag will apply to)
			#
			# @param [Fixnum] value Tag value.
			# @return [void]
			def tag(value)
				@@bfr ||= FFI::Buffer.new(:uchar, 9)
				stream.write(
					@@bfr.get_bytes(0, LibCBOR.cbor_encode_tag(value, @@bfr, 9))
				)
			end

			# Encodes indefinite item break code.
			#
			# @return [void]
			def break
				stream.write("\xff")
			end

			protected

			attr_accessor :stream
		end
	end
end