require "./spec_helper"

describe HttpSignatures::Algorithm do

  {
    "hmac-sha1" => "bXPeVc5ySIyeUapN7mpMsJRnxVg=",
    "hmac-sha256" => "hRQ5zpbGudR1hokS4PqeAkveKmz2dd8SCgV8OHcramI=",
  }.each do |name, base64_signature|

    describe ".create('#{name}')" do
      key = "the-key"
      input = "the string\nto sign"
      algorithm = HttpSignatures::Algorithm.create(name)
      it "has #name == '#{name}'" do
        algorithm.name.should eq(name)
      end
      it "produces known-good signature" do
        signature = algorithm.sign(key, input)
        signature.should eq(Base64.decode_string(base64_signature))
      end
    end

  end

  it "raises error for unknown algorithm" do
    expect_raises(HttpSignatures::Algorithm::UnknownAlgorithm) do
      HttpSignatures::Algorithm.create(:nope)
    end
  end

end