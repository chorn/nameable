#!/usr/bin/env ruby

require "rubygems"
require "lib/nameable"

DATA.each do |testcase|
  n = Nameable::Latin.new.parse(testcase)
  puts "``#{testcase.chomp}'' -> #{n.to_fullname}"
end

__END__
Mr. Chris Horn PhD
Chris Horn T.I.T.L.E.
Chris Horn II
Chris Horn II Esquire
Chris O'Horn
Chris McHorn
Chris Von Horn
Chris O' Horn
Chris K Horn - Horn
CHRIS HORN
CHRIS-HORN
CHRIS;HORN
