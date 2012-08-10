#!/usr/bin/env ruby

require "rubygems"
require "./lib/nameable"

DATA.each do |testcase|
  n = Nameable::Latin.new.parse(testcase)
  puts "``#{testcase.chomp}'' -> #{n.first} #{n.last}  //  #{n.to_fullname}"
end

__END__
HORN, CHRIS K
HORN, CHRIS K.
Mr. Chris Horn PhD
Chris Horn T.I.T.L.E.
Chris Horn II
Chris Horn II Esquire
Chris Horn I.I.I.
Chris O'Horn
Chris McHorn
Chris Von Horn
Chris O' Horn
Chris K Horn
Chris K. Horn
Chris K Horn Sr
Chris Horn - Horn
Chris Ole Biscuit Barrel Horn
CHRIS HORN
CHRIS-HORN
CHRIS;HORN
Horn, Chris
Horn, Chris K
Horn, Chris K.
Horn, Chris K. DDS
Horn,,Chris
Horn,, Chris
Horn , , Chris
Horn ,, Chris
Chris Horn, Ph.D. DB CCNE
CHRIS MC HORN
CHRIS MAC HORN
CHRIS VAN HORN
CHRIS DA HORN
CHRIS DE HORN
CHRIS ST HORN
CHRIS ST. HORN
