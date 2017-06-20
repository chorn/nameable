require 'spec_helper'

describe Object do
  it 'returns a string' do
    expect(Nameable('Chris Horn')).to be_a(String)
  end

  it 'raises an exception' do
    expect { Nameable(nil) }.to raise_error Nameable::InvalidNameError
  end
end
