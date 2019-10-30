module HttpSignatures
  class HeaderList

    # cannot sign the signature headers
    ILLEGAL = ["authorization", "signature"]

    def self.from_string(string)
      new(string.split(" "))
    end

    @names : Array(String)
    def initialize(names : Array(String))
      @names = names.map(&.downcase)
      validate_names!
    end

    def to_a
      @names.dup
    end

    def to_str
      @names.join(" ")
    end

    private def validate_names!
      if @names.empty?
        raise EmptyHeaderList.new
      end
      if illegal_headers_present.any?
        raise IllegalHeader.new illegal_headers_present
      end
    end

    private def illegal_headers_present
      ILLEGAL & @names
    end

    class IllegalHeader < Exception
      def initialize(names)
        names_string = names.map { |n| "'#{n}'" }.join(", ")
        super("Header #{names_string} not permitted")
      end
    end

    class EmptyHeaderList < Exception; end

  end
end