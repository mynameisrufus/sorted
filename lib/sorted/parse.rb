require 'sorted/set'

module Sorted
  module Parse
    def split(raw, delim, &block)
      return Set.new if raw.nil?
      raw.to_s.split(delim).inject(Set.new, &block)
    end

    def parse_match(raw)
      return parse_sort_with_direction(raw) if raw[5].nil?

      parse_sort_without_direction(raw)
    end

    def parse_sort_with_direction(raw)
      parsed = []
      parsed << parse_column(raw[1], raw[2])
      parsed << parse_direction(raw[3])
      parsed << parse_nulls(raw[4]) unless raw[4].nil?
      parsed
    end

    def parse_sort_without_direction(raw)
      parsed = []
      parsed << parse_column(raw[1], raw[5])
      parsed << parse_nulls(raw[6]) unless raw[6].nil?
      parsed
    end

    def parse_column(raw_all_content, raw_column)
      raw_column || raw_all_content
    end

    def parse_direction(raw_direction)
      raw_direction.nil? ? 'asc' : raw_direction.downcase
    end

    def parse_nulls(raw_nulls)
      raw_nulls.downcase
    end
  end
end
