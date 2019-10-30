module HttpSignatures
  class Verification

    @parsed_parameters : Hash(String, String) | Nil

    def initialize(message : HTTP::Request, key_store : KeyStore)
      @message = message
      @key_store = key_store
    end

    def valid?
      signature_header_present? && VerificationAlgorithm.create(algorithm).valid?(
        message: @message,
        key: key,
        header_list: header_list,
        provided_signature_base64: provided_signature_base64
      )
    rescue SignatureParametersParser::Error
      false
    end

    private def signature_header_present?
      @message.headers.has_key?("Signature")
    end

    private def provided_signature_base64
      parsed_parameters.fetch("signature") { nil }
    end

    private def key
      @key_store.fetch(parsed_parameters["keyId"])
    end

    private def algorithm
      Algorithm.create(parsed_parameters["algorithm"])
    end

    private def header_list
      HeaderList.from_string(parsed_parameters["headers"])
    end

    private def parsed_parameters
      @parsed_parameters ||= SignatureParametersParser.new(fetch_header("Signature")).parse
    end

    private def fetch_header(name)
      @message.headers[name]
    end

  end
end