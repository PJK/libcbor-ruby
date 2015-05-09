require 'spec_helper'

module CBOR
	describe '.load_native' do
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

			it 'returns uint type' do
				expect(subject.type).to eq :negint
			end

			it 'returns value -2' do
				expect(subject.value).to eq -2
			end
		end

		context 'for definite string "Hello"' do
			subject { CBOR.load_native("\x65Hello") }

			it 'returns uint type' do
				expect(subject.type).to eq :string
			end

			it 'returns value "Hello"' do
				expect(subject.value).to eq 'Hello'
			end
		end
	end
end