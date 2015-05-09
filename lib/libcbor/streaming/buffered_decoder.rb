module CBOR
	module Streaming
		class BufferedDecoder
			def initialize(callbacks)
				@callbacks = {
					integer: Proc.new {},
					string: Proc.new {},
					chunked_string_start: Proc.new {},
					bytestring: Proc.new {},
					chunked_bytestring_start: Proc.new {},
					float: Proc.new {},
					definite_array: Proc.new {},
					array_start: Proc.new {},
					array_end: Proc.new {},
					definite_map: Proc.new {},
					map_start: Proc.new {},
					map_end: Proc.new {},
					tag: Proc.new {},
					bool: Proc.new {},
					null: Proc.new {},
					simple: Proc.new {},
				}.merge(callbacks)
				@buffer = ''
			end

			def <<(data)
				@buffer += data
				# emit events
			end


			attr_reader :buffer
		end
	end
end