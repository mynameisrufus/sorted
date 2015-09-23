require 'sorted/set'
require 'sorted/parse'

module Sorted
  ##
  # Parses an array of decoded query params
  #
  # This parser/encoder uses an already decoded array of sort strings parsed by
  # a URI library.
  #
  # Parsing:
  #
  #   params = ['phone_desc', 'name_asc']
  #   set = Sorted::ParamsQuery.parse(params)
  #   set.to_a #=> [['phone', 'desc'], ['name', asc']]
  #
  # Encoding:
  #
  #   Sorted::ParamsQuery.encode(set) #=> ['phone_desc', 'name_asc']

  class ParamsQuery
    extend Parse

    REGEXP = /(([a-z0-9._]+)_([asc|desc]+)|[a-z0-9._]+)/i

    def self.parse(params)
      params.inject(Set.new) do |set, part|
        m = part.match(REGEXP)
        next unless m
        set << parse_match(m)
      end
    end

    def self.encode(set)
      set.map { |a| a.join('_') }
    end
  end
end
