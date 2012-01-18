#!/usr/bin/env ruby

require "rubygems"
require "./lib/nameable"

DATA.each do |testcase|
  n = Nameable::Latin.new.parse(testcase)
  puts "``#{testcase.chomp}'' -> #{n.to_fullname}"
end

__END__
HORN, CHRIS K
HORN, CHRIS K.
Mr. Chris Horn PhD
Chris Horn T.I.T.L.E.
Chris Horn II
Chris Horn II Esquire
Chris O'Horn
Chris McHorn
Chris Von Horn
Chris O' Horn
Chris K Horn
Chris K. Horn
Chris Horn - Horn
Chris Ole Biscuit Barrel Horn
CHRIS HORN
CHRIS-HORN
CHRIS;HORN
Horn, Chris
Horn, Chris K
Horn, Chris K.
Horn, Chris K. DDS
Chris Horn, Ph.D. DB CCNE
