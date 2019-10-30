require "./spec_helper"
require "http"

describe HttpSignatures::Verifier do

  key_store = HttpSignatures::KeyStore.new({"pda" => "secret"})
  verifier = HttpSignatures::Verifier.new(key_store: key_store)
  signature_header =
    %(keyId="%s",algorithm="%s",headers="%s",signature="%s") % [
      "pda",
      "hmac-sha256",
      "(request-target) date",
      "cS2VvndvReuTLy52Ggi4j6UaDqGm9hMb4z0xJZ6adqU=",
    ]
  headers = HTTP::Headers.new
  headers.add("Date", "Fri, 01 Aug 2014 13:44:32 -0700")
  headers.add("Signature", signature_header)
  message = HTTP::Request.new("GET", "/path?query=123", headers)

  it "verifies a valid message" do
    verifier.valid?(message).should eq(true)
  end

  it "rejects message with tampered path" do
    message.path = "x"
    verifier.valid?(message).should eq(false)
  end

  it "rejects message with tampered date" do
    message.headers["Date"] = "Fri, 01 Aug 2014 13:44:33 -0700"
    verifier.valid?(message).should eq(false)
  end

  it "rejects message with tampered signature" do
    message.headers["Signature"] = message.headers["Signature"].sub("signature=\"", "signature=\"x")
    verifier.valid?(message).should eq(false)
  end

  it "rejects message with malformed signature" do
    message.headers["Signature"] = "foo=bar,baz=bla,yadda=yadda"
    verifier.valid?(message).should eq(false)
  end

  it "rejects message with missing headers" do
    message.headers.clear
    verifier.valid?(message).should eq(false)
  end
end