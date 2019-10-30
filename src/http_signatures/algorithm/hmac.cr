module HttpSignatures
  module Algorithm
    class Hmac

      def initialize(algorithm : OpenSSL::Algorithm)
        @algorithm = algorithm
      end

      def name
        "hmac-#{@algorithm.to_s.underscore}"
      end

      def sign(key, data)
        String.new(OpenSSL::HMAC.digest(@algorithm, key, data))
      end

    end
  end
end