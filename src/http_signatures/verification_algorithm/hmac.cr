module HttpSignatures
  class VerificationAlgorithm
    class Hmac
      def initialize(algorithm : Algorithm::Hmac)
        @algorithm = algorithm
      end

      def valid?(message, key, header_list, provided_signature_base64)
        expected_signature_base64(message, key, header_list) == provided_signature_base64
      end

      def expected_signature_base64(message, key, header_list)
        Base64.strict_encode(expected_signature_raw(message, key, header_list))
      end

      def expected_signature_raw(message, key, header_list)
        Signature.new(
          message: message,
          key: key,
          algorithm: @algorithm,
          header_list: header_list,
        ).to_str
      end
    end
  end
end