module HttpSignatures
  class Verifier

    def initialize(key_store : KeyStore)
      @key_store = key_store
    end

    def valid?(message)
      Verification.new(message: message, key_store: @key_store).valid?
    end

  end
end