module CBOR
	module Streaming
		class BufferedDecoder
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
			end

			def <<(data)
				@buffer += data
				# emit events
			end

			def callback(name, *args)
				callbacks[name].call(*args)
			end

			attr_reader :buffer

			protected

			attr_reader :callbacks
		end
	end
end