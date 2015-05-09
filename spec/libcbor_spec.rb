require 'spec_helper'

describe CBOR do
  it 'has a version number' do
    expect(CBOR::VERSION).not_to be nil
  end
end
