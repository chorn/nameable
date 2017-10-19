require 'nameable/latin/patterns'

module Nameable
  module Parser
    def self.match_lastname_firstname(string)
      string.match(/^(?<lastish>[a-z]+)\s*,+[\s,]*(?<firstish>[^,]*)/i)
    end

    def self.reverse_lastname_firstname(string)
      matches = match_lastname_firstname(string)
      if matches
        "#{matches[:firstish]} #{matches[:lastish]}"
      else
        string
      end
    end

    def self.force_to_string(input)
      if input.respond_to?(:join)
        input.join(' ').strip
      else
        input.to_s.strip
      end
    end

    def self.parse_into_list(input)
      reverse_lastname_firstname(force_to_string(input)).split(/\s+/)
    end

    def self.extract_prefix(list)
      return unless list && !list.size.zero?

      first = list.first
      prefix = nil

      Nameable::Latin::Patterns::PREFIX.each do |pretty, regex|
        if first.match(regex)
          prefix = pretty
          break
        end
      end

      list.delete(first) if prefix
      prefix
    end
  end
end
