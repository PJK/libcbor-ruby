require 'spec_helper'

module CBOR
	describe Item do
		context 'upon invalid FFI return value' do
			it 'fails predictably' do
				expect(LibCBOR).to receive(:cbor_typeof).and_return(:foo)
				expect {
					Item.new(double).value
				}.to raise_exception /Unknown type/
			end
		end
	end
end