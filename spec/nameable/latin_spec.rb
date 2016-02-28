require 'spec_helper'

describe Nameable::Latin do
  describe '.new' do
    it "doesn't raise" do
      expect { Nameable::Latin.new }.to_not raise_error
    end
  end

  context('with a single word name') do
    subject(:n) { Nameable::Latin.new.parse("Chris") }
    it '.parse' do
      expect(n.prefix).to be_nil
      expect(n.first).to eq('Chris')
      expect(n.middle).to be_nil
      expect(n.last).to be_nil
      expect(n.suffix).to be_nil
    end
  end

  context('with a simple name') do
    subject(:n) { Nameable::Latin.new.parse("Chris Horn") }
    it '.prefix' do
      expect(n.prefix).to be_nil
    end
    it '.first' do
      expect(n.first).to eq('Chris')
    end
    it '.middle' do
      expect(n.middle).to be_nil
    end
    it '.last' do
      expect(n.last).to eq('Horn')
    end
    it '.suffix' do
      expect(n.suffix).to be_nil
    end
  end

  context('with an all uppercase name') do
    subject(:n) { Nameable::Latin.new.parse("CHRIS HORN") }
    it '.first' do
      expect(n.first).to eq('Chris')
    end
    it '.last' do
      expect(n.last).to eq('Horn')
    end
  end

  context('with an all lowercase name') do
    subject(:n) { Nameable::Latin.new.parse("chris horn") }
    it '.first' do
      expect(n.first).to eq('Chris')
    end
    it '.last' do
      expect(n.last).to eq('Horn')
    end
  end

  context('with a mixed case name') do
    subject(:n) { Nameable::Latin.new.parse("DeChris HORN") }
    it '.first' do
      expect(n.first).to eq('DeChris')
    end
  end

  context('with a simple middle name') do
    subject(:n) { Nameable::Latin.new.parse("Chris Derp Horn") }
    it '.prefix' do
      expect(n.prefix).to be_nil
    end
    it '.first' do
      expect(n.first).to eq('Chris')
    end
    it '.middle' do
      expect(n.middle).to eq('Derp')
    end
    it '.last' do
      expect(n.last).to eq('Horn')
    end
    it '.suffix' do
      expect(n.suffix).to be_nil
    end
  end

  context('with a simple prefix') do
    subject(:n) { Nameable::Latin.new.parse("Sir Chris Horn") }
    it '.prefix' do
      expect(n.prefix).to eq('Sir')
    end
    it '.first' do
      expect(n.first).to eq('Chris')
    end
    it '.middle' do
      expect(n.middle).to be_nil
    end
    it '.last' do
      expect(n.last).to eq('Horn')
    end
    it '.suffix' do
      expect(n.suffix).to be_nil
    end
  end

  context('with a simple suffix') do
    subject(:n) { Nameable::Latin.new.parse("Chris Horn PhD") }
    it '.prefix' do
      expect(n.prefix).to be_nil
    end
    it '.first' do
      expect(n.first).to eq('Chris')
    end
    it '.middle' do
      expect(n.middle).to be_nil
    end
    it '.last' do
      expect(n.last).to eq('Horn')
    end
    it '.suffix' do
      expect(n.suffix).to eq('Ph.D.')
    end
  end

  context('prefix patterns') do
    %w{Mr Mr. Mister}.each do |prefix|
      it prefix do
       expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Mr.')
      end
    end

    %w{Mrs Mrs. Misses}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Mrs.')
      end
    end

    %w{Ms Ms. Miss}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Ms.')
      end
    end

    %w{Dr Dr. Doctor}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Dr.')
      end
    end

    %w{Rev Rev. Reverand}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Rev.')
      end
    end

    %w{Fr Fr. Friar Father}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Fr.')
      end
    end

    %w{Dame Rabbi Imam Master Sir}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq(prefix)
      end
    end

    %w{Hon Hon. Honorable}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Hon.')
      end
    end

    %w{Capt Capt. Captain}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Capt.')
      end
    end

    %w{Ofc Ofc. Officer}.each do |prefix|
      it prefix do
        expect(Nameable::Latin.new.parse("#{prefix} Chris Horn").prefix).to eq('Ofc.')
      end
    end
  end

  context('suffix patterns (formatted)') do
    %w{Sr Sr. Senior}.each do |suffix|
      it suffix do
        expect(Nameable::Latin.new.parse("Chris Horn #{suffix}").suffix).to eq('Sr.')
      end
    end

    %w{Jr Jr. Junior}.each do |suffix|
      it suffix do
        expect(Nameable::Latin.new.parse("Chris Horn #{suffix}").suffix).to eq('Jr.')
      end
    end

    %w{Esq Esq. Esquire}.each do |suffix|
      it suffix do
        expect(Nameable::Latin.new.parse("Chris Horn #{suffix}").suffix).to eq('Esq.')
      end
    end

    %w{PHD PhD Ph.D Ph.D. P.H.D.}.each do |suffix|
      it suffix do
        expect(Nameable::Latin.new.parse("Chris Horn #{suffix}").suffix).to eq('Ph.D.')
      end
    end

  end

  context('suffix patterns (generational)') do
    %w{ii III iv V VI ix Xiii}.each do |suffix|
      it suffix do
        expect(Nameable::Latin.new.parse("Chris Horn #{suffix}").suffix).to eq(suffix.upcase)
      end
    end
  end

  context('suffix patterns (common)') do
    %w{APR RPh MD MA DMD DDS PharmD EngD DPhil JD DD DO BA BS BSc BE BFA MA MS MSc MFA MLA MBA PE CSA CPA CPL CME CEng OFM CSV}.each do |suffix|
      it suffix do
        expect(Nameable::Latin.new.parse("Chris Horn #{suffix}").suffix).to eq(suffix.upcase)
      end
    end
  end

  context('suffix patterns (generic uppercase)') do
    it 'generic DERP suffix' do
      expect(Nameable::Latin.new.parse("Chris Horn DERP").suffix).to eq('DERP')
    end

    it 'no generic DERP suffix when all uppercase name' do
      expect(Nameable::Latin.new.parse("CHRIS HORN DERP").suffix).to be_nil
    end
  end

  context('multi word last names') do
    %w{mc vere von van da de del della di da pietro vanden du st la ter ten}.each do |prefix|
      it "#{prefix} Last" do
        expect(Nameable::Latin.new.parse("Chris #{prefix} Last").last).to eq("#{prefix.downcase.capitalize} Last")
      end
    end
  end

  context("o'last-name") do
    it "O'Horn" do
      expect(Nameable::Latin.new.parse("Chris O'Horn").last).to eq("O'Horn")
    end

    it "O`Horn" do
      expect(Nameable::Latin.new.parse("Chris O`Horn").last).to eq("O'Horn")
    end

    it "O' Horn" do
      expect(Nameable::Latin.new.parse("Chris O' Horn").last).to eq("O'Horn")
    end
  end

  context("hyphenated last names") do
    it "Horn - Derp" do
      expect(Nameable::Latin.new.parse("Chris Horn - Derp").last).to eq("Horn-Derp")
    end

    it "Horn-Derp" do
      expect(Nameable::Latin.new.parse("Chris Horn-Derp").last).to eq("Horn-Derp")
    end

    it "Horn--Derp" do
      expect(Nameable::Latin.new.parse("Chris Horn--Derp").last).to eq("Horn-Derp")
    end

    it "Horn -- Derp" do
      expect(Nameable::Latin.new.parse("Chris Horn--Derp").last).to eq("Horn-Derp")
    end
  end

  context("gender") do
    it "Chris is more likely to be male" do
      expect(Nameable::Latin.new.parse("Chris Horn").male?).to be true
    end

    it "Janine is more likely to be female" do
      expect(Nameable::Latin.new.parse("Janine Horn").female?).to be true
    end

    it "Derp has :unknown gender" do
      expect(Nameable::Latin.new.parse("Derp Horn").gender).to eq(:unknown)
    end
  end

  context("ethnicity") do
    it "Horn has a hash of ethnicity results" do
      expect(Nameable::Latin.new.parse("Chris Horn").ethnicity).to be_a Hash
    end

    it "Horn's census :percent_white > 80% " do
      expect(Nameable::Latin.new.parse("Chris Horn").ethnicity[:percent_white]).to be >= 80
    end
  end

end
