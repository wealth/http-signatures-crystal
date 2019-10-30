require "spec"
require "../src/http_signatures"

def make_request(method, path, headers_hash)
  headers = HTTP::Headers.new
  headers_hash.each do |k, v|
    headers.add(k, v)
  end
  message = HTTP::Request.new(method, path, headers)
end