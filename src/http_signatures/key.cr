module HttpSignatures
  class Key

    def initialize(id : String, secret : String)
      @id = id
      @secret = secret
    end

    getter :id
    getter :secret

    def ==(other)
      self.class == other.class &&
        self.id == other.id &&
        self.secret == other.secret
    end

  end
end