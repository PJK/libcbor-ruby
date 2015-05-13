module CBOR
	# Represents Simple value other than those that have native Ruby mapping
	class SimpleValue < Struct.new(:value)
		def ==(other)
			if other.is_a? SimpleValue
				other.value == value
			end
		end
	end
end