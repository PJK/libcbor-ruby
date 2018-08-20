module CBOR
	module Streaming
		# Decodes a stream of data and invokes the appropriate callbacks
		#
		# To use it, just initialize it with the desired set of callbacks and start
		# feeding data to it. Please see {file:examples/network_streaming.rb} for
		# an example
		class BufferedDecoder
			# @param [Hash] callbacks the callbacks to invoke during parsing.
			# @option callbacks [Proc<Integer>] :integer Integers, both positive and negative
			# @option callbacks [Proc<String>] :string Definite string
			# @option callbacks [Proc] :chunked_string_start Chunked string. Chunks follow
			# @option callbacks [Proc<String>] :byte_string Definite byte string
			# @option callbacks [Proc] :chunked_byte_string_start Chunked byte string. Chunks follow
			# @option callbacks [Proc<Float>] :float Float
			# @option callbacks [Proc<length: Integer>] :definite_array Definite array
			# @option callbacks [Proc] :array_start Indefinite array start
			# @option callbacks [Proc<length: Integer>] :definite_map Definite map. Length pairs follow
			# @option callbacks [Proc] :map_start Indefinite map start
			# @option callbacks [Proc<value: Integer>] :tag Tag. Tagged item follows
			# @option callbacks [Proc<Bool>] :bool Boolean
			# @option callbacks [Proc] :null Null
			# @option callbacks [Proc<value: Integer>] :simple Simple value other than +true, false, nil+
			# @option callbacks [Proc] :break Indefinite item break
			def initialize(callbacks = {})
				@callbacks = {
					integer: Proc.new {},
					string: Proc.new {},
					chunked_string_start: Proc.new {},
					byte_string: Proc.new {},
					chunked_byte_string_start: Proc.new {},
					float: Proc.new {},
					definite_array: Proc.new {},
					array_start: Proc.new {},
					definite_map: Proc.new {},
					map_start: Proc.new {},
					tag: Proc.new {},
					bool: Proc.new {},
					null: Proc.new {},
					simple: Proc.new {},
					break: Proc.new {},
				}.merge(callbacks)
				@buffer = ''
				@proxy = CallbackSimplifier.new(self)
			end

			# Append data to the internal buffer.
			#
			# Parsing will ensue and all the appropriate callbacks will be invoked.
			# The method will block until all the callbacks have finished.
			#
			# @param [String] data CBOR input data
			# @return [void]
			# @raise [DecodingError] if the decoder encountered a invalid input
			def <<(data)
				@buffer += data
				loop do
					result = LibCBOR.cbor_stream_decode(
						FFI::MemoryPointer.from_string(@buffer),
						@buffer.bytes.length,
						@proxy.callback_set.to_ptr,
						nil
					)
					read = result[:read]

					break if read == 0 && result[:status] == :not_enough_data

					unless result[:status] == :finished
						raise DecodingError, "Invalid input near byte #{read} of the buffer."
					end

					@buffer = @buffer[read .. -1]

					break if buffer.empty?
				end
			end

			# @api private
			# Invocation target for the callback proxy. Do not use.
			#
			# @param [Symbol] name Callback name
			# @param [Array] args Arguments to pass on
			# @return [void]
			def callback(name, *args)
				callbacks[name].call(*args)
			end

			attr_reader :buffer

			protected

			attr_reader :callbacks
		end
	end
end
