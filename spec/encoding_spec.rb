require 'spec_helper'

module CBOR
	describe 'Encoding' do
		it 'raises for unknown classes' do
			expect { CBOR.encode(:beer) }.to raise_exception UndefinedConversion
		end

		describe Fixnum do
			it 'returns correct bytes' do
				expect(2.__to_cbor).to eq "\x02"
				expect(-2.__to_cbor).to eq "\x21"
			end
		end

		describe String do
			it 'returns correct bytes' do
				expect("Hello".__to_cbor.bytes).to eq [101] + "Hello".bytes

			end
		end

		describe Float do
			it 'returns correct bytes' do
				expect(3.14.__to_cbor.bytes).to eq [250, 64, 72, 245, 195]
			end
		end

		describe Array do
			it 'returns correct bytes' do
				expect([1, 2].__to_cbor.bytes).to eq [0x82, 1, 2]
			end
		end

		describe Hash do
			it 'returns correct bytes' do
				expect({ 1 => 2 }.__to_cbor.bytes).to eq [0xA1, 1, 2]
			end
		end

		describe Tag do
			it 'returns correct bytes' do
				expect(Tag.new(42, 0).__to_cbor.bytes).to eq [0xD8,  0x2A, 0]
			end
		end

		describe 'simple values' do
			describe true do
				it 'returns correct bytes' do
					expect(true.__to_cbor.bytes).to eq [0xF5]
				end
			end

			describe false do
				it 'returns correct bytes' do
					expect(false.__to_cbor.bytes).to eq [0xF4]
				end
			end

			describe 'nil' do
				it 'returns correct bytes' do
					expect(nil.__to_cbor.bytes).to eq [0xF6]
				end
			end
		end
	end
end