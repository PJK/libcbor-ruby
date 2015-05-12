module CBOR
	module Streaming
		# @api private
		# Abstracts aways callback specifics, such as integer width
		class CallbackSimplifier < Struct.new(:target)
			# Returns the appropriate callback set targeting {#target}. Cached for the
			# give instance.
			#
			# @return [LibCBOR::CborCallbacks] Callback set that enables forwarding
			def callback_set
				@cset ||= build_callback_set
			end

			protected

			def build_callback_set
				callbacks = LibCBOR::CborCallbacks.new
				callbacks[:uint8] = Proc.new { |_ctx, val| target.callback(:integer, val) }
				callbacks[:uint16] = callbacks[:uint8]
				callbacks[:uint32] = callbacks[:uint8]
				callbacks[:uint64] = callbacks[:uint8]

				callbacks[:negint8] = Proc.new { |_ctx, val| target.callback(:integer, -val - 1) }
				callbacks[:negint16] = callbacks[:negint8]
				callbacks[:negint32] = callbacks[:negint8]
				callbacks[:negint64] = callbacks[:negint8]

				callbacks[:byte_string] = Proc.new { |_ctx, ptr, size|
					target.callback(:byte_string, ptr.get_string(0, size))
				}
				callbacks[:byte_string_start] = Proc.new { |_ctx| target.callback(:chunked_byte_string_start) }

				callbacks[:string] = Proc.new { |_ctx, ptr, size|
					target.callback(:string, ptr.get_string(0, size))
				}
				callbacks[:string_start] = Proc.new { |_ctx| target.callback(:chunked_string_start) }

				callbacks[:array_start] = Proc.new { |_ctx, size| target.callback(:definite_array, size) }
				callbacks[:indef_array_start] = Proc.new { |_ctx| target.callback(:array_start) }

				callbacks[:map_start] = Proc.new { |_ctx, size| target.callback(:definite_map, size) }
				callbacks[:indef_map_start] = Proc.new { |_ctx| target.callback(:map_start) }

				callbacks[:tag] = Proc.new { |_ctx, val| target.callback(:tag, val) }

				callbacks[:float2] = Proc.new { |_ctx, val| target.callback(:float, val) }
				callbacks[:float4] = callbacks[:float2]
				callbacks[:float8] = callbacks[:float2]

				callbacks[:undefined] = Proc.new { |_ctx| target.callback(:simple, 23) }
				callbacks[:null] = Proc.new { |_ctx| target.callback(:null) }
				callbacks[:boolean] = Proc.new { |_ctx, val| target.callback(:bool, val) }

				callbacks[:indef_break] = Proc.new { |_ctx| target.callback(:break) }

				callbacks
			end
		end
	end
end
