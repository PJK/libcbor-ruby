require 'spec_helper'

# TODO use oneline assertions
describe CBOR do
	describe '.decode' do
		context 'for invalid inputs' do
			it 'raises a sensible exception' do
				expect { CBOR.decode("\x65") }.to raise_exception CBOR::DecodingError
			end
		end

		context 'for uint 3' do
			subject { CBOR.decode("\x03") }

			it 'returns value 3' do
				expect(subject).to eq 3
			end
		end

		context 'for neint -2' do
			subject { CBOR.decode("\x21") }

			it 'returns value -2' do
				expect(subject).to eq -2
			end
		end

		context 'for definite string "Hello"' do
			subject { CBOR.decode("\x65Hello") }

			it 'returns value "Hello"' do
				expect(subject).to eq 'Hello'
			end
		end

		context 'for definite bytestring "\x42"' do
			subject { CBOR.decode("\x41\x42") }


			it 'returns value "\x42"' do
				expect(subject).to eq "\x42"
			end
		end

		context 'for array [1, 2]' do
			subject { CBOR.decode("\x82\x1\x2") }

			it 'returns value [1, 2]' do
				expect(subject).to eq [1, 2]
			end
		end

		context 'for map {1: 2, 3:4}' do
			subject { CBOR.decode("\xA2\x1\x2\x3\x4") }

			it 'returns value [1, 2]' do
				expect(subject).to eq({ 1 => 2, 3 => 4})
			end
		end

		context 'for tag 42(0)' do
			subject { CBOR.decode("\xD8\x2a\x0") }

			it 'returns correct Tag object' do
				expect(subject).to eq CBOR::Tag.new(42, 0)
			end
		end

		context 'for "true" simple value' do
			subject { CBOR.decode("\xF5") }


			it 'returns value "true"' do
				expect(subject).to eq true
			end
		end

		context 'for "false" simple value' do
			subject { CBOR.decode("\xF4") }

			it 'provides translation' do
				expect(subject).to eq false
			end
		end

		context 'for "0" simple value' do
			subject { CBOR.decode("\xE8\xFF") }

			#TODO: enable this after libcbor is fixed
			xit 'provides translation' do
				expect(subject).to eq SimpleValue.new(255)
			end
		end

		context 'for 3.14 float' do
			subject { CBOR.decode([250, 64, 72, 245, 195].pack('c*')) }


			it 'returns value 3.14' do
				expect(subject).to be_within(0.0001).of(3.14)
			end
		end
	end
end