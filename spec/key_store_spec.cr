require "./spec_helper"

describe HttpSignatures::KeyStore do

  describe "#fetch" do
    store = HttpSignatures::KeyStore.new({
      "hello" => "world",
      "another" => "key",
    })

    it "retrieves keys" do
      store.fetch("hello").should eq(
        HttpSignatures::Key.new(id: "hello", secret: "world")
      )
    end
    it "raises KeyError" do
      expect_raises(KeyError) do
        store.fetch("nope")
      end
    end
  end

end