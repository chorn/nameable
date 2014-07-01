require "nameable/version"
require "nameable/error"
require "nameable/latin"
require "nameable/extensions"

module Nameable
  def self.parse(name)
    Nameable::Latin.new.parse(name)
  end
end
