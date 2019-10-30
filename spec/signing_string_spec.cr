require "./spec_helper"
require "http"

describe HttpSignatures::SigningString do

  date = "Tue, 29 Jul 2014 14:17:02 -0700"

  describe "#to_str" do
    headers = HTTP::Headers.new
    headers.add("date", date)
    headers.add("x-herring", "red")
    message = HTTP::Request.new("GET", "/path?query=123", headers)
    

    it "returns correct signing string" do
      header_list = HttpSignatures::HeaderList.from_string("(request-target) date")
      signing_string = HttpSignatures::SigningString.new(header_list: header_list, message: message)

      signing_string.to_str.should eq(
        "(request-target): get /path?query=123\n" +
        "date: #{date}"
      )
    end

    context "for header not in message" do
      header_list = HttpSignatures::HeaderList.from_string("nope")
      signing_string = HttpSignatures::SigningString.new(header_list: header_list, message: message)
      it "raises HeaderNotInMessage" do
        expect_raises(HttpSignatures::HeaderNotInMessage) do
          signing_string.to_str
        end
      end
    end

  end

end