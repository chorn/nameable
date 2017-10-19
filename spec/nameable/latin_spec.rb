require 'spec_helper'

shared_examples :generalized_parsing do |input, outputs|
  let(:nameable) { Nameable::Latin.new.parse(input) }

  it "#parse ``#{input}''" do
    expect(nameable.prefix).to eq outputs[0]
    expect(nameable.first).to eq outputs[1]
    expect(nameable.middle).to eq outputs[2]
    expect(nameable.last).to eq outputs[3]
    expect(nameable.suffix).to eq outputs[4]
  end
end

describe Nameable::Latin do
  describe '.new' do
    it "doesn't raise" do
      expect { Nameable::Latin.new }.to_not raise_error
    end
  end

  describe '#parse' do
    context 'with a single word name' do
      it_behaves_like :generalized_parsing, 'ZChris', [nil, 'Chris', nil, nil, nil]
    end

    context 'with a simple first and last name' do
      it_behaves_like :generalized_parsing, 'Chris Horn', [nil, 'Chris', nil, 'Horn', nil]
    end

    context 'with an uppercase first and last name' do
      it_behaves_like :generalized_parsing, 'CHRIS HORN', [nil, 'Chris', nil, 'Horn', nil]
    end

    context 'with a lowercase first and last name' do
      it_behaves_like :generalized_parsing, 'chris horn', [nil, 'Chris', nil, 'Horn', nil]
    end

    context 'with a mixed case first and last name' do
      it_behaves_like :generalized_parsing, 'DeChris Horn', [nil, 'DeChris', nil, 'Horn', nil]
    end

    context 'with last name, first name' do
      it_behaves_like :generalized_parsing, 'Horn, Chris', [nil, 'Chris', nil, 'Horn', nil]
    end

    context 'with last name, first name,' do
      it_behaves_like :generalized_parsing, 'Horn, Chris,', [nil, 'Chris', nil, 'Horn', nil]
    end

    context 'with first middle last name' do
      it_behaves_like :generalized_parsing, 'Chris Derp Horn', [nil, 'Chris', 'Derp', 'Horn', nil]
    end

    context 'with all uppercase first middle last name' do
      it_behaves_like :generalized_parsing, 'CHRIS DERP HORN', [nil, 'Chris', 'Derp', 'Horn', nil]
    end

    context 'with all lowercase first middle last name' do
      it_behaves_like :generalized_parsing, 'chris derp horn', [nil, 'Chris', 'Derp', 'Horn', nil]
    end

    context 'with all mixed case first middle last name' do
      it_behaves_like :generalized_parsing, 'DeChris LeDerp ZeHorn', [nil, 'DeChris', 'LeDerp', 'ZeHorn', nil]
    end

    context 'with first last suffix' do
      it_behaves_like :generalized_parsing, 'Chris Horn DRP', [nil, 'Chris', nil, 'Horn', 'DRP']
    end

    context 'with prefix first last suffix' do
      it_behaves_like :generalized_parsing, 'Mr. Chris Horn DRP', ['Mr.', 'Chris', nil, 'Horn', 'DRP']
    end

    %w[Dame Rabbi Imam Master Sir].each do |prefix|
      it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", [prefix, 'Chris', nil, 'Horn', nil]
    end

    context 'with a normalizing prefix' do
      %w[Mr Mr. Mister].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Mr.', 'Chris', nil, 'Horn', nil]
      end

      %w[Mrs Mrs. Misses].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Mrs.', 'Chris', nil, 'Horn', nil]
      end

      %w[Ms Ms. Miss].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Ms.', 'Chris', nil, 'Horn', nil]
      end

      %w[Dr Dr. Doctor].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Dr.', 'Chris', nil, 'Horn', nil]
      end

      %w[Rev Rev. Reverend].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Rev.', 'Chris', nil, 'Horn', nil]
      end

      %w[Fr Fr. Friar Father].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Fr.', 'Chris', nil, 'Horn', nil]
      end

      %w[Hon Hon. Honorable].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Hon.', 'Chris', nil, 'Horn', nil]
      end

      %w[Capt Capt. Captain].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Capt.', 'Chris', nil, 'Horn', nil]
      end

      %w[Ofc Ofc. Officer].each do |prefix|
        it_behaves_like :generalized_parsing, "#{prefix} Chris Horn", ['Ofc.', 'Chris', nil, 'Horn', nil]
      end
    end

    context 'with a normalizing suffix' do
      %w[Sr Sr. Senior].each do |suffix|
        it_behaves_like :generalized_parsing, "Chris Horn #{suffix}", [nil, 'Chris', nil, 'Horn', 'Sr.']
      end

      %w[Jr Jr. Junior].each do |suffix|
        it_behaves_like :generalized_parsing, "Chris Horn #{suffix}", [nil, 'Chris', nil, 'Horn', 'Jr.']
      end

      %w[Esq Esq. Esquire].each do |suffix|
        it_behaves_like :generalized_parsing, "Chris Horn #{suffix}", [nil, 'Chris', nil, 'Horn', 'Esq.']
      end

      %w[PHD PhD Ph.D Ph.D. P.H.D.].each do |suffix|
        it_behaves_like :generalized_parsing, "Chris Horn #{suffix}", [nil, 'Chris', nil, 'Horn', 'Ph.D.']
      end

      %w[
        ii III iv V VI ix Xiii APR RPh MD MA DMD DDS PharmD EngD DPhil
        JD DD DO BA BS BSc BE BFA MA MS MSc MFA MLA MBA PE CSA CPA CPL CME CEng OFM CSV
      ].each do |suffix|
        it_behaves_like :generalized_parsing, "Chris Horn #{suffix}", [nil, 'Chris', nil, 'Horn', suffix.upcase]
      end
    end

    context 'with a multi word last name' do
      %w[mc vere von van da de del della di da pietro vanden du st la ter ten].each do |prefix|
        it_behaves_like :generalized_parsing, "Chris #{prefix} Horn", [nil, 'Chris', nil, "#{prefix.downcase.capitalize} Horn", nil]
      end
    end

    context "with an o'last-name" do
      ["O'Horn", 'O`Horn', "O' Horn"].each do |last|
        it_behaves_like :generalized_parsing, "Chris #{last}", [nil, 'Chris', nil, "O'Horn", nil]
      end
    end

    context 'with a hyphenated last name' do
      ['Horn - Derp', 'Horn-Derp',  'Horn--Derp', 'Horn -- Derp'].each do |last|
        it_behaves_like :generalized_parsing, "Chris #{last}", [nil, 'Chris', nil, 'Horn-Derp', nil]
      end
    end
  end

  # context 'gender' do
  #   it 'Chris is more likely to be male' do
  #     expect(Nameable::Latin.new.parse('Chris Horn').male?).to be true
  #   end
  #
  #   it 'Janine is more likely to be female' do
  #     expect(Nameable::Latin.new.parse('Janine Horn').female?).to be true
  #   end
  #
  #   it 'Derp has :unknown gender' do
  #     expect(Nameable::Latin.new.parse('Derp Horn').gender).to eq(:unknown)
  #   end
  # end
  #
  # context 'ethnicity' do
  #   it 'Horn has a hash of ethnicity results' do
  #     expect(Nameable::Latin.new.parse('Chris Horn').ethnicity).to be_a Hash
  #   end
  #
  #   it "Horn's census :percent_white > 80% " do
  #     expect(Nameable::Latin.new.parse('Chris Horn').ethnicity[:percent_white]).to be >= 80
  #   end
  # end
end
