require "./spec_helper"

describe HttpSignatures::Context do

  message = make_request("GET", "/", { "date" => "x", "content-length" => "0" })

  context "with one key in KeyStore, no signing_key_id specified" do
    context = HttpSignatures::Context.new(
      keys: {"hello" => "world"},
      algorithm: "hmac-sha256",
      headers: %w{(request-target) date content-length},
    )

    describe "#signer" do
      # it "instantiates Signer with key, algorithm, headers" do
      #   expect(HttpSignatures::Signer).to receive(:new) do |args|
      #     expect(args[:key]).to eq(HttpSignatures::Key.new(id: "hello", secret: "world"))
      #     expect(args[:algorithm].name).to eq("hmac-sha256")
      #     expect(args[:header_list].to_a).to eq(%w{(request-target) date content-length})
      #   end
      #   context.signer
      # end

      it "signs without errors" do
        context.signer.sign(message)
      end

      it "verifies without errors" do
        signature_parameters = %(keyId="hello",algorithm="hmac-sha1",headers="date",signature="x")
        message = make_request("GET", "/", { "Date" => "x", "Signature" => signature_parameters })
        context.verifier.valid?(message)
      end
    end
  end

  context "with two keys in KeyStore, signing_key_id specified" do
    context = HttpSignatures::Context.new(
      keys: {"hello" => "world", "another" => "key"},
      signing_key_id: "another",
      algorithm: "hmac-sha256",
      headers: %w{(request-target) date content-length},
    )

    describe "#signer" do
      # it "instantiates Signer with key, algorithm, headers" do
      #   expect(HttpSignatures::Signer).to receive(:new) do |args|
      #     expect(args[:key]).to eq(HttpSignatures::Key.new(id: "another", secret: "key"))
      #     expect(args[:algorithm].name).to eq("hmac-sha256")
      #     expect(args[:header_list].to_a).to eq(%w{(request-target) date content-length})
      #   end
      #   context.signer
      # end

      it "signs without errors" do
        message = make_request("GET", "/", { "date" => "x", "content-length" => "0" })

        context.signer.sign(message)
      end
    end
  end

end