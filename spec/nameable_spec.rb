context("convenience") do
  it 'to_s' do
    expect(Nameable("Chris Horn")).to be_a(String)
  end

  it 'parse' do
    expect(Nameable.parse("Chris Horn")).to be_a(Nameable::Latin)
  end
end
