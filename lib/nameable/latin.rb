require 'csv'
require 'nameable/error'
require 'nameable/latin/patterns'

module Nameable
  class Latin
    @@first_names = {}
    @@last_names = {}

    attr_accessor :prefix, :first, :middle, :last, :suffix

    ##
    def initialize(*args)
      if args.size == 1 && args.first.class == Hash
        parts = args.first
        @prefix = parts[:prefix]  ? parts[:prefix]  : nil
        @first  = parts[:first]   ? parts[:first]   : nil
        @middle = parts[:middle]  ? parts[:middle]  : nil
        @last   = parts[:last]    ? parts[:last]    : nil
        @suffix = parts[:suffix]  ? parts[:suffix]  : nil
      else
        @first = args.shift if args.size > 0
        @middle = args.shift if args.size >= 2 # Only grab a middle name if we've got a last name left
        @last = args.shift if args.size > 0
      end
    end

    ##
    # name is an Array
    def extract_prefix(name)
      return unless name and name.size > 1 and @prefix.nil? and @first.nil?
      Nameable::Latin::Patterns::PREFIX.each_pair do |pretty, regex|
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

        Nameable::Latin::Patterns::SUFFIX.each_pair do |pretty, regex|
          suff = pretty if name[n] =~ regex
        end

        if name[n] =~ Nameable::Latin::Patterns::SUFFIX_ACADEMIC or name[n] =~ Nameable::Latin::Patterns::SUFFIX_PROFESSIONAL or name[n] =~ Nameable::Latin::Patterns::SUFFIX_GENERATIONAL_ROMAN
          suff = name[n].upcase.gsub(/\./,'')
        end

        if !suff && name.join != name.join.upcase and name[n].length > 1 and name[n] =~ Nameable::Latin::Patterns::SUFFIX_ABBREVIATION
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

      @last = name.last.gsub(/['`"]+/, "'").gsub(/-+/, '-')
      name.delete_at(name.size - 1)

      @last.capitalize! unless @last =~ /[a-z]/ and @last =~ /[A-Z]/
    end

    ##
    # name is an Array
    def extract_middle(name)
      return unless name and name.size >= 1

      (name.size - 1).downto(0) do |n|
        next unless name[n]

        if name[n] =~ Nameable::Latin::Patterns::LAST_NAME_PRE_DANGLERS
          @last = "#{name[n].downcase.capitalize} #{@last}"
        elsif name[n] =~ Nameable::Latin::Patterns::O_LAST_NAME_PRE_CONCATS
          @last = "O'#{@last}"
        elsif name[n] =~ /\-/ and n > 0 and name[n-1]
          @last = "#{name[n-1].gsub(/\-/, '')}-#{@last}"
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

    # http://www.ssa.gov/oact/babynames/limits.html
    def load_huge_gender_table(gender_table=Nameable::Assets::GENDER_TABLE)
      ranked = {}

      CSV.read(gender_table).each do |first, gender, rank|
        first.downcase!
        gender.downcase!
        ranked[first] = {} unless ranked[first]
        ranked[first][gender] = rank.to_i
      end

      ranked.each do |first, ranks|
        if ranks['m'] && !ranks['f']
          @@first_names[first] = :male
        elsif !ranks['m'] && ranks['f']
          @@first_names[first] = :female
        elsif ranks['m'] && ranks['f']
          @@first_names[first] = ranks['m'] > ranks['f'] ? :male : :female
        end
      end
    end

    # http://www.census.gov/genealogy/www/data/2000surnames/index.html
    def load_huge_ethnicity_table
      CSV.read(File.expand_path(File.join('..', '..', '..', 'data', 'app_c.csv'), __FILE__)).each do |name, rank, count, prop100k, cum_prop100k, pctwhite, pctblack, pctapi, pctaian, pct2prace, pcthispanic|
        next if name == 'name'
        @@last_names[name.downcase] = {
          rank:rank.to_i,
          count:count.to_i,
          percent_white:pctwhite.to_f,
          percent_black:pctblack.to_f,
          percent_asian_pacific_islander:pctapi.to_f,
          percent_american_indian_alaska_native:pctaian.to_f,
          percent_two_or_more_races:pct2prace.to_f,
          percent_hispanic:pcthispanic.to_f
        }
      end
    end

    def gender
      return @gender if @gender
      load_huge_gender_table unless @@first_names && @@first_names.size > 0
      @gender = @@first_names[@first.to_s.downcase] ? @@first_names[@first.to_s.downcase] : :unknown
      @gender
    end

    def ethnicity
      return @ethnicity if @ethnicity
      load_huge_ethnicity_table unless @@last_names && @@last_names.size > 0
      @ethnicity = (@last && @@last_names[@last.downcase]) ? @@last_names[@last.downcase] : :unknown
      @ethnicity
    end

    def male?
      self.gender == :male
    end

    def female?
      self.gender == :female
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
