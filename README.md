# nameable

[![Gem Version](https://badge.fury.io/rb/nameable.svg)](http://badge.fury.io/rb/nameable)
[![Build Status](https://travis-ci.org/chorn/nameable.svg?branch=master)](https://travis-ci.org/chorn/nameable)

A library that provides parsing and normalization of people's names.

```ruby
require 'nameable'
n = Nameable::Latin.new.parse('Mr. Chris K Horn Esquire')
puts "#{n.prefix} #{n.first} #{n.middle} #{n.last} #{n.suffix}"
#=> Mr. Chris K Horn Esq.
puts n.to_fullname
#=> Mr. Chris K. Horn, Esq.
n = Nameable::Latin.new('CHRIS', 'HORN')
puts n.to_nameable
#=> Chris Horn
n = Nameable::Latin.new(prefix:'Sir', last:'Horn')
puts n
#=> Sir Horn
```

# Features

Convenience methods:

```ruby
puts Nameable('chris horn, iii')
#=> "Chris Horn, III."
puts Nameable.parse('chris horn, iii')
#=> #<Nameable::Latin:0x007f8470e01b08 @first="Chris", @last="Horn", @middle=nil, @prefix=nil, @suffix="III.">
```

Using a database of first names from the U.S. Social Security Administration, Nameable will pick the most likely gender for a name.

```ruby
Nameable::Latin.new('Chris').gender
#=> :male
Nameable::Latin.new('Janine').female?
#=> true
```

Using a database of last names from the U.S. Census, Nameable will return the ethnicity breakdown as a Hash.

```ruby
Nameable::Latin.new('Chris', 'Horn').ethnicity
#=> {:rank=>593, :count=>51380, :percent_white=>86.75, :percent_black=>8.31, :percent_asian_pacific_islander=>0.84, :percent_american_indian_alaska_native=>1.16, :percent_two_or_more_races=>1.46, :percent_hispanic=>1.48}
```

# Other uses

I've included a little web service, which should be installed as "nameable_web_service" that requires sinatra.  It's been handy when paired with OpenRefine, if I'm working with a file and I am not going to be parsing with Ruby.  If you're reading this, that's probably not an issue for you, but I do think it's a nice way to show someone how to use OpenRefine in a more advanced way.

# Inspiration

By inspiration, I should really say "other projects from which I yanked their code, ideas, examples and data." At worst I'll make sure the other projects I looked at and borrowed from are credited here.

# Security

As of version `1.1.1`., the nameable gem is cryptographically signed. To be sure the gem you install hasn’t been tampered with, add my public key as a trusted certificate, and verify that nameable and any dependencies it has are also signed:

```
$ gem cert --add <(curl -Ls https://raw.github.com/chorn/nameable/master/certs/chorn.pem)
$ gem install nameable -P HighSecurity
```

# References

* [Open Refine](http://openrefine.org/) formerly [Google Refine](https://code.google.com/p/google-refine/)
* [Help with splitting names](http://www.onlineaspect.com/2009/08/17/splitting-names/)
* [First Names from the U.S. SSA](http://www.ssa.gov/oact/babynames/limits.html)
* [Last Names from the Census](http://www.census.gov/topics/population/genealogy/data/2000_surnames.html)
* [Data Science Toolkit](https://github.com/petewarden/dstk)
* [Addressable](https://github.com/sporkmonger/addressable)

# To-do

1. Extract all of the US Census / Ethnicity / Asset stuff out of `Latin`. Yuck, that's ugly why did I ever do that?
2. Rename `Latin` to be `US` or `English` because it's looks like I really only support English, and probably US English.
3. Use named captures for all the regexs.
4. Refactor the Ethnicity stuff into a class.
5. Refactor parsing into a class.

-chorn
