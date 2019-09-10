require 'spec_helper'

module CBOR
	describe 'Encoding' do
		before(:all) { CBOR.load! }

		describe Integer do
			it 'returns correct bytes' do
				expect(2.to_cbor).to eq "\x02"
				expect(-2.to_cbor).to eq "\x21"
			end
		end

		describe String do
			it 'returns correct bytes' do
				expect("Hello".to_cbor.bytes).to eq [101] + "Hello".bytes
			end

                        it "returns corrects bytes when binary encoding" do
				word = "Hello".b

				expect(word.to_cbor.bytes).to eq [0b010_00000 + word.length] + word.bytes
                        end
                end

                describe ByteString do
                        it "returns corrects bytes" do
				word = CBOR::ByteString.new("Hello")

				expect(word.to_cbor.bytes).to eq [0b010_00000 + word.length] + word.bytes
                        end
		end

		describe Float do
			it 'returns correct bytes' do
				expect(3.14.to_cbor.bytes).to eq [250, 64, 72, 245, 195]
			end
		end

		describe Array do
			it 'returns correct bytes' do
				expect([1, 2].to_cbor.bytes).to eq [0x82, 1, 2]
			end
		end

		describe Hash do
			it 'returns correct bytes' do
				expect({ 1 => 2 }.to_cbor.bytes).to eq [0xA1, 1, 2]
			end
		end

		describe Tag do
			it 'returns correct bytes' do
				expect(Tag.new(42, 0).to_cbor.bytes).to eq [0xD8,  0x2A, 0]
			end
		end

		describe 'simple values' do
			describe true do
				it 'returns correct bytes' do
					expect(true.to_cbor.bytes).to eq [0xF5]
				end
			end

			describe false do
				it 'returns correct bytes' do
					expect(false.to_cbor.bytes).to eq [0xF4]
				end
			end

			describe 'nil' do
				it 'returns correct bytes' do
					expect(nil.to_cbor.bytes).to eq [0xF6]
				end
			end
		end
	end
end
