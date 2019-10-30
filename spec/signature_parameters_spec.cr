require "./spec_helper"

describe HttpSignatures::SignatureParameters do

  describe "#to_str" do
    # key = instance_double("HttpSignatures::Key", id: "pda")
    # algorithm = instance_double("HttpSignatures::Algorithm::Hmac", name: "hmac-test")
    # header_list = instance_double("HttpSignatures::HeaderList", to_str: "a b c")
    # signature = instance_double("HttpSignatures::Signature", to_str: "sigstring")

    key = HttpSignatures::Key.new("pda", "")
    algorithm = HttpSignatures::Algorithm::Hmac.new(OpenSSL::Algorithm::SHA1)
    header_list = HttpSignatures::HeaderList.new(["a", "b", "c"])
    headers = HTTP::Headers.new
    headers.add("a", "av")
    headers.add("b", "bv")
    headers.add("c", "cv")

    signature_parameters = HttpSignatures::SignatureParameters.new(
      key: key,
      algorithm: algorithm,
      header_list: header_list,
      signature: HttpSignatures::Signature.new(HTTP::Request.new("POST", "/", headers), key, algorithm, header_list),
    )
    it "builds parameters into string" do
      signature_parameters.to_str.should eq(
        %(keyId="pda",algorithm="hmac-sha1",headers="a b c",signature="X/VAM6w+Gt+vUcY1uiDyq9932NE=")
      )
    end
  end

end