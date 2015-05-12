module CBOR
	# Represents a tagged item -- a pair of number and the item
	#
	# @attr [Fixnum] value The tag value
	# @attr [Object] item The tagged item
	class Tag < Struct.new(:value, :item)
		def ==(other)
			if other.is_a? Tag
				value == other.value && item == other.item
			end
		end
	end
end