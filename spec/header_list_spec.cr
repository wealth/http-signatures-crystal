require "./spec_helper"

describe HttpSignatures::HeaderList do

  describe ".from_string" do
    it "loads and normalizes header names" do
      HttpSignatures::HeaderList.from_string("(request-target) Date Content-Type").to_str.should eq("(request-target) date content-type")
    end
  end

  describe ".new" do
    it "normalizes header names (downcase)" do
      list = HttpSignatures::HeaderList.new(["(request-target)", "Date", "Content-Type"])
      list.to_a.should eq(["(request-target)", "date", "content-type"])
    end

    ["Authorization", "Signature"].each do |header|
      it "raises IllegalHeader for #{header} header" do
        expect_raises(HttpSignatures::HeaderList::IllegalHeader) do
          HttpSignatures::HeaderList.new([header])
        end
      end
    end
  end

  describe "#to_str" do
    it "joins normalized header names with spaces" do
      list = HttpSignatures::HeaderList.new(["(request-target)", "Date", "Content-Type"])
      list.to_str.should eq("(request-target) date content-type")
    end
  end

end