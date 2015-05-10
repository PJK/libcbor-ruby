module CBOR
	# Represents a tagged item -- a pair of number and the item
	#
	# @attr [Fixnum] value The tag value
	# @attr [Object] item The tagged item
	class Tag < Struct.new(:value, :item)
	end
end