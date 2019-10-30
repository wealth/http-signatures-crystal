require "./spec_helper"
require "http"

describe HttpSignatures::Signer do
  key = HttpSignatures::Key.new(id: "pda", secret: "sh")
  algorithm = HttpSignatures::Algorithm::Hmac.new(:sha256)
  header_list = HttpSignatures::HeaderList.new(["date", "content-type"])

  signer = HttpSignatures::Signer.new(key: key, algorithm: algorithm, header_list: header_list)

  headers = HTTP::Headers.new
  headers.add("date", "Mon, 28 Jul 2014 15:39:13 -0700")
  headers.add("Content-Type", "text/plain")
  headers.add("Content-Length", "123")
  message = HTTP::Request.new("GET", "/path?query=123", headers)

  authorization_structure_pattern =
    %r{
      \A
      Signature
      \s
      keyId="[\w-]+",
      algorithm="[\w-]+",
      (?:headers=".*",)?
      signature="[a-zA-Z0-9/+=]+"
      \z
    }x

  signature_structure_pattern =
    %r{
      \A
      keyId="[\w-]+",
      algorithm="[\w-]+",
      (?:headers=".*",)?
      signature="[a-zA-Z0-9/+=]+"
      \z
    }x

  describe "#sign" do
    # it "passes correct signing string to algorithm" do
    #   expect(algorithm).to receive(:sign).with(
    #     "sh",
    #     ["date: #{EXAMPLE_DATE}", "content-type: text/plain"].join("\n")
    #   ).at_least(:once).and_return("static")
    #   signer.sign(message)
    # end
    it "returns reference to the mutated input" do
      signer.sign(message).should eq(message)
    end
  end

  context "after signing" do
    signer.sign(message)
    it "has valid Authorization header structure" do
      message.headers["Authorization"].should match(authorization_structure_pattern)
    end
    it "has valid Signature header structure" do
      message.headers["Signature"].should match(signature_structure_pattern)
    end
    it "matches expected Authorization header" do
      message.headers["Authorization"].should eq(
        %(Signature keyId="pda",algorithm="hmac-sha256",) +
          %(headers="date content-type",signature="0ZoJq6cxYZRXe+TN85whSuQgJsam1tRyIal7ni+RMXA=")
      )
    end
    it "matches expected Signature header" do
      message.headers["Signature"].should eq(
        %(keyId="pda",algorithm="hmac-sha256",) +
          %(headers="date content-type",signature="0ZoJq6cxYZRXe+TN85whSuQgJsam1tRyIal7ni+RMXA=")
      )
    end
  end

end