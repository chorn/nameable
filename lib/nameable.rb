# Copyright (c) 2012 Chris Horn http://chorn.com/
# See MIT-LICENSE.txt

# TODO: Make this less sucky.

module Nameable
  class Latin

    ##
    # Raised if something other than a valid Name is supplied
    class InvalidNameError < StandardError
    end

    ##
    # Regex's to match the detritus that people add to their names
    module Patterns
      PREFIX = {
        "Mr."    => /^\(*(mr\.*|mister)\)*$/i,
        "Mrs."   => /^\(*(mrs\.*|misses)\)*$/i,
        "Ms."    => /^\(*(ms\.*|miss)\)*$/i,
        "Dr."    => /^\(*(dr\.*|doctor)\)*$/i,
        "Rev."   => /^\(*(rev\.*|reverand)\)*$/i,
        "Fr."    => /^\(*(fr\.*|friar)\)*$/i,
        "Master" => /^\(*(master)\)*$/i,
        "Sir"    => /^\(*(sir)\)*$/i
      }

      SUFFIX = {
        "Sr."   => /^\(*(sr\.?|senior)\)*$/i,
        "Jr."   => /^\(*(jr\.?|junior)\)*$/i,
        "Esq."  => /^\(*(esq\.?|esquire)\)*$/i,
        "Ph.D." => /^\(*(phd\.?)\)*$/i
      }

      SUFFIX_GENERATIONAL_ROMAN = /^\(*[IVX\.]+\)*$/i
      SUFFIX_ACADEMIC = /^(APR|RPh|MD|MA|DMD|DDS|PharmD|EngD|DPhil|JD|DD|DO|BA|BS|BSc|BE|BFA|MA|MS|MSc|MFA|MLA|MBA)$/i
      SUFFIX_PROFESSIONAL = /^(PE|CSA|CPA|CPL|CME|CEng|OFM|CSV|Douchebag)$/i
      SUFFIX_ABBREVIATION = /^[A-Z\.]+[A-Z\.]+$/  # It should be at least 2 letters

      LAST_NAME_PRE_DANGLERS = /^(mc|vere|von|van|da|de|del|della|di|da|pietro|vanden|du|st|la|ter|ten)$/i
      O_LAST_NAME_PRE_CONCATS = /^(o'|o`)$/i
      # MC_LAST_NAME_PRE_CONCAT = /^(mc|da|de)$/i
      # ST_LAST_NAME_PRE_CONCAT = /^(st)\.*$/i
    end

    attr_accessor :prefix, :first, :middle, :last, :suffix

    ##
    #
    def initialize(parts={})
      self.prefix = parts[:prefix]  ? parts[:prefix]  : nil
      self.first  = parts[:first]   ? parts[:first]   : nil
      self.middle = parts[:middle]  ? parts[:middle]  : nil
      self.last   = parts[:last]    ? parts[:last]    : nil
      self.suffix = parts[:suffix]  ? parts[:suffix]  : nil
    end

    ##
    # name is an Array
    def extract_prefix(name)
      return unless name and name.size > 1 and @prefix.nil? and @first.nil?
      Patterns::PREFIX.each_pair do |pretty, regex|
        if name.first =~ regex
          @prefix = pretty
          name.delete(name.first)
          return
        end
      end
    end

    ##
    # name is an Array
    def extract_suffix(name)
      return unless name and name.size >= 3

      (name.size - 1).downto(2) do |n|
        suff = nil

        Patterns::SUFFIX.each_pair do |pretty, regex|
          suff = pretty if name[n] =~ regex
        end

        if name[n] =~ Patterns::SUFFIX_ACADEMIC or name[n] =~ Patterns::SUFFIX_PROFESSIONAL or name[n] =~ Patterns::SUFFIX_GENERATIONAL_ROMAN
          suff = name[n].upcase.gsub(/\./,'')
        end

        if name.join != name.join.upcase and name[n].length > 1 and name[n] =~ Patterns::SUFFIX_ABBREVIATION
          suff = name[n].upcase.gsub(/\./,'')
        end

        if suff
          @suffix = @suffix ? "#{suff}, #{@suffix}" : suff
          name.delete_at(n)
        end

      end
    end

    ##
    # name is an Array
    def extract_first(name)
      return unless name and name.size >= 1

      @first = name.first
      name.delete_at(0)

      @first.capitalize! unless @first =~ /[a-z]/ and @first =~ /[A-Z]/
    end

    ##
    # name is an Array
    def extract_last(name)
      return unless name and name.size >= 1

      @last = name.last
      name.delete_at(name.size - 1)

      @last.capitalize! unless @last =~ /[a-z]/ and @last =~ /[A-Z]/
    end

    ##
    # name is an Array
    def extract_middle(name)
      return unless name and name.size >= 1

      (name.size - 1).downto(0) do |n|
        next unless name[n]

        if name[n] =~ Patterns::LAST_NAME_PRE_DANGLERS
          @last = "#{name[n].downcase.capitalize} #{@last}"
        elsif name[n] =~ Patterns::O_LAST_NAME_PRE_CONCATS
          @last = "O'#{@last}"
        # elsif name[n] =~ Patterns::MC_LAST_NAME_PRE_CONCAT
        #   @last = "#{name[n].downcase.capitalize} #{@last}"
        # elsif name[n] =~ Patterns::ST_LAST_NAME_PRE_CONCAT
        #   @last = "St. #{@last}"
        elsif name[n] =~ /-+/ and n > 0 and name[n-1]
          @last = "#{name[n-1]}-#{@last}"
          name[n-1] = nil
        else
          @middle = @middle ? "#{name[n]} #{@middle}" : name[n]
        end

        name.delete_at(n)
      end

      @middle.capitalize! if @middle and !(@middle =~ /[a-z]/ and @middle =~ /[A-Z]/)
      @middle = "#{@middle}." if @middle and @middle.size == 1
    end

    def parse(name)
      raise InvalidNameError unless name
      if name.class == String
        if name.index(',')
          name = "#{$2} #{$1}" if name =~ /^([a-z]+)\s*,\s*,*(.*)/i
        end

        name = name.strip.split(/\s+/)
      end

      name = name.first.split(/[^[:alnum:]]+/) if name.size == 1 and name.first.split(/[^[:alnum:]]+/)

      extract_prefix(name)
      extract_suffix(name)
      extract_first(name)
      extract_last(name)
      extract_middle(name)

      raise InvalidNameError, "A parseable name was not found. #{name.inspect}" unless @first

      self
    end

    def to_s
      [@prefix, @first, @middle, @last].compact.join(' ') + (@suffix ? ", #{@suffix}" : "")
    end

    def to_name
      to_nameable
    end

    def to_fullname
      to_s
    end

    def to_prefix
      @prefix
    end

    def to_firstname
      @first
    end

    def to_lastname
      @last
    end

    def to_middlename
      @middle
    end

    def to_suffix
      @suffix
    end

    def to_nameable
      [@first, @last].compact.join(' ')
    end

    def to_hash
      return {
        :prefix => @prefix,
        :first => @first,
        :middle => @middle,
        :last => @last,
        :suffix => @suffix
      }
    end
  end
end
