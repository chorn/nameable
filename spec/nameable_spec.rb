require 'spec_helper'

describe Nameable::Latin do
  describe "with 'Mr. Chris Horn PhD" do
    subject { Nameable::Latin.new.parse("Mr. Chris Horn PhD") }

    it("should extract prefix") { subject.prefix.should == "Mr." }
    it("should extract first name") { subject.first.should == "Chris" }
    it("should extract last name") { subject.last.should == "Horn" }
    it("should extract and normalize suffix") { subject.suffix.should == "Ph.D." }
  end

  describe "with 'Chris Old Biscuit Barrel Horn'" do
    subject { Nameable::Latin.new.parse("Chris Old Biscuit Barrel Horn") }

    it("should extract first name") { subject.first.should == "Chris" }
    it("should extract middle name") { subject.middle.should == "Old Biscuit Barrel" }
    it("should extract last name") { subject.last.should == "Horn" }
  end

end
