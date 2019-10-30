module HttpSignatures
  class KeyStore

    def initialize(key_hash)
      @keys = {} of String => Key
      key_hash.each { |id, secret| self[id] = secret }
    end

    def fetch(id)
      @keys.dig(id)
    end

    def only_key
      if @keys.one?
        @keys.values.first
      else
        raise KeyError.new("Expected 1 key, found #{@keys.size}")
      end
    end

    private def []=(id, secret)
      @keys[id] = Key.new(id: id, secret: secret)
    end

  end
end