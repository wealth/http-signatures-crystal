module HttpSignatures
  class SignatureParametersParser

    def initialize(string : String)
      @string = string
    end

    def parse
      array_of_pairs.to_h
    end

    private def array_of_pairs
      segments.map { |segment| pair(segment) }
    end

    private def segments
      @string.split(",")
    end

    private def pair(segment)
      match = segment_pattern.match(segment)
      raise Error.new("parsing error at segment: #{segment}") if match.nil?
      Tuple(String, String).from(match.captures)
    end

    private def segment_pattern
      /\A(keyId|algorithm|headers|signature)="(.*)"\z/
    end

    class Error < Exception; end

  end
end