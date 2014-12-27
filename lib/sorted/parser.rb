require 'sorted/toggler'

module Sorted
  ##
  # Takes a sort query string and an SQL order string and parses the
  #
  # values to produce key value pairs.
  #
  # Example:
  #  Sorted::Parser.new('phone_desc', 'name ASC').to_s #=> "phone_desc!name_asc"
  #
  #  TODO A more helpfull name than `Parser` because it only deals with URI and
  #  SQL. Shoud be refactored before 2.x

  Parser = Struct.new(:sort, :order) do
    def uri
      URIQuery.parse(sort)
    end

    def sql
      SQLQuery.parse(order)
    end

    def sorts
      uri.to_a
    end

    def orders
      sql.to_a
    end

    def to_hash
      set.to_hash
    end

    def to_sql(quote_proc = ->(f) { f })
      SQLQuery.encode(set, quote_proc)
    end

    def to_s
      URIQuery.encode(set)
    end

    def to_a
      set.to_a
    end

    def toggle
      @set = Toggler.new(orders, sorts).toggle
      self
    end

    def reset
      @set = default
      self
    end

    private

    def set
      @set ||= default
    end

    def default
      uri + (sql - uri)
    end
  end
end
