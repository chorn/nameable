require 'spec_helper'

describe Nameable do
  it '.parse' do
    expect(Nameable.parse('Chris Horn')).to be_a(Nameable::Latin)
  end
end
