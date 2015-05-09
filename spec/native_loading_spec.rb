require 'spec_helper'

module CBOR
	describe '.load_native' do
		context 'for invalid inputs' do
			it 'raises a sensible exception' do
				expect { CBOR.load_native("\x65") }.to raise_exception DecodingError
			end
		end

		context 'for uint 3' do
			subject { CBOR.load_native("\x03") }

			it 'returns uint type' do
				expect(subject.type).to eq :uint
			end

			it 'returns value 3' do
				expect(subject.value).to eq 3
			end
		end

		context 'for neint -2' do
			subject { CBOR.load_native("\x21") }

			it 'returns negint type' do
				expect(subject.type).to eq :negint
			end

			it 'returns value -2' do
				expect(subject.value).to eq -2
			end
		end

		context 'for definite string "Hello"' do
			subject { CBOR.load_native("\x65Hello") }

			it 'returns string type' do
				expect(subject.type).to eq :string
			end

			it 'returns value "Hello"' do
				expect(subject.value).to eq 'Hello'
			end
		end

		context 'for definite bytestring "\x42"' do
			subject { CBOR.load_native("\x41\x42") }

			it 'returns bytestring type' do
				expect(subject.type).to eq :bytestring
			end

			it 'returns value "\x42"' do
				expect(subject.value).to eq "\x42"
			end
		end

		context 'for array [1, 2]' do
			subject { CBOR.load_native("\x82\x1\x2") }

			it 'returns array type' do
				expect(subject.type).to eq :array
			end

			it 'returns value [1, 2]' do
				expect(subject.value).to eq [1, 2]
			end
		end

		context 'for "true" simple value' do
			subject { CBOR.load_native("\xF5") }

			it 'returns float_ctrl type' do
				expect(subject.type).to eq :float_ctrl
			end

			it 'returns value "true"' do
				expect(subject.value).to eq true
			end
		end

		context 'for 3.14 float' do
			subject { CBOR.load_native([250, 64, 72, 245, 195].pack('c*')) }

			it 'returns float_ctrl type' do
				expect(subject.type).to eq :float_ctrl
			end

			it 'returns value 3.14' do
				expect(subject.value).to be_within(0.0001).of(3.14)
			end
		end
	end
end