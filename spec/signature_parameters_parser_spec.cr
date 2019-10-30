require "./spec_helper"

describe HttpSignatures::SignatureParametersParser do

  describe "#parse" do
    it "returns hash with string keys matching those in the parsed string" do
      input = %(keyId="example",algorithm="hmac-sha1",headers="(request-target) date",signature="b64")
      parser = HttpSignatures::SignatureParametersParser.new(input)
      parser.parse.should eq(
        {
          "keyId" => "example",
          "algorithm" => "hmac-sha1",
          "headers" => "(request-target) date",
          "signature" => "b64",
        }
      )
    end

    context "with invalid input" do
      input = %(foo="bar",algorithm="hmac-sha1",headers="(request-target) date",signature="b64")
      parser = HttpSignatures::SignatureParametersParser.new(input)
      it "fails with explanatory error message" do
        expect_raises(HttpSignatures::SignatureParametersParser::Error) do
          parser.parse
        end
      end
    end
  end

end