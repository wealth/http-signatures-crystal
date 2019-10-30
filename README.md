# http-signatures-crystal

Copy of (https://github.com/99designs/http-signatures-ruby) ported to Crystal. Some specs omitted, but should generally work.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     http-signatures-crystal:
       github: wealth/http-signatures-crystal
   ```

2. Run `shards install`

## Usage

```crystal
require "http-signatures-crystal"

context = HttpSignatures::Context.new(
  keys: {"examplekey" => "secret-key-here"},
  algorithm: "hmac-sha256",
  headers: ["(request-target)", "Date", "Content-Length"],
)

headers = HTTP::Headers.new
headers.add("Date", Time.now.rfc822)
headers.add("Content-Length", "0")

message = HTTP::Request.new(
  "GET",
  "/path?query=123",
  headers
)

context.signer.sign(message)

puts message.headers["Signature"]
puts message.headers["Authorization"]

puts context.verifier.valid?(message)
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/wealth/http-signatures-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [wealth](https://github.com/wealth) - creator and maintainer
