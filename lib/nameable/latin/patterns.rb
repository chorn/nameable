module Nameable
  class Latin
    # Regex's to match the detritus that people add to their names
    module Patterns
      PREFIX = {
        'Capt.'  => /^\(*(?<prefix>capt\.*|captain)\)*$/i,
        'Dame'   => /^\(*(?<prefix>dame)\)*$/i,
        'Dr.'    => /^\(*(?<prefix>dr\.*|doctor)\)*$/i,
        'Fr.'    => /^\(*(?<prefix>fr\.*|friar|father)\)*$/i,
        'Hon.'	 => /^\(*(?<prefix>hon\.*|honorable)\)*$/i,
        'Imam'   => /^\(*(?<prefix>imam)\)*$/i,
        'Ofc.'   => /^\(*(?<prefix>ofc\.*|officer)\)*$/i,
        'Mr.'    => /^\(*(?<prefix>mr\.*|mister)\)*$/i,
        'Mrs.'   => /^\(*(?<prefix>mrs\.*|misses)\)*$/i,
        'Ms.'    => /^\(*(?<prefix>ms\.*|miss)\)*$/i,
        'Rev.'   => /^\(*(?<prefix>rev\.*|reverend)\)*$/i,
        'Master' => /^\(*(?<prefix>master)\)*$/i,
        'Rabbi'  => /^\(*(?<prefix>rabbi)\)*$/i,
        'Sir'    => /^\(*(?<prefix>sir)\)*$/i
      }.freeze

      SUFFIX = {
        'Sr.'   => /^\(*(?<suffix>sr\.?|senior)\)*$/i,
        'Jr.'   => /^\(*(?<suffix>jr\.?|junior)\)*$/i,
        'Esq.'  => /^\(*(?<suffix>esq\.?|esquire)\)*$/i,
        'Ph.D.' => /^\(*(?<suffix>p\.?h\.?d\.?)\)*$/i
      }.freeze

      SUFFIX_GENERATIONAL_ROMAN = /^\(*[IVX.]+\)*$/i
      SUFFIX_ACADEMIC = /^(APR|RPh|MD|MA|DMD|DDS|PharmD|EngD|DPhil|JD|DD|DO|BA|BS|BSc|BE|BFA|MA|MS|MSc|MFA|MLA|MBA)$/i
      SUFFIX_PROFESSIONAL = /^(PE|CSA|CPA|CPL|CME|CEng|OFM|CSV)$/i
      SUFFIX_ABBREVIATION = /^[A-Z]\.?[A-Z]\.?[A-Z]?\.?$/ # 2-3 characters, possibly separated with '.'

      # http://www.onlineaspect.com/2009/08/17/splitting-names/
      LAST_NAME_PRE_DANGLERS = /^(mc|vere|von|van|da|de|del|della|di|da|pietro|vanden|du|st|la|ter|ten)$/i
      O_LAST_NAME_PRE_CONCATS = /^(o'|o`|o")$/i
    end
  end
end
