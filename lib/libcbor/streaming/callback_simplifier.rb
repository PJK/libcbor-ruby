module CBOR
	module Streaming
		# Abstracts aways callback specifics, such as integer width
		class CallbackSimplifier
			Uint8 = Proc.new { |_ctx, val| uint(val) }
			def uint(x)
				puts x
			end
		end
	end
end
