# Claude

Claude transparently encrypts and decrypts sensitive Active Record attributes.
Nothing magical or fancy, just a simple `OpenSSL::Cipher` wrapper.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'claude'
```

And then execute:

```bash
bundle
```

## Usage

Say, you have to store sensitive information in your application database. You
can use `OpenSSL::Cipher` to manually encrypt the value with a secret on write,
and decrypt it with the same secret when used throughout the code base. This
may work for a single sensitive attribute, but it gets out of hand if you gotta
do it regularly.

Claude wraps `OpenSSL::Cipher` and lets you transparently encrypt and decrypt
the your application sensitive attributes, so you don't have to do it manually
all the time.

Claude exposes the `encrypt` and `attr_encrypt` class macros to setup an
attribute encryption.

```ruby
class Card < ActiveRecord::Base
  encrypt :pin
end

>> card = Card.new(pin: "1234")
=> #<Card id: nil, encrypted_pin: "FNYLjh2q9tWcYH5lG0zkPQ==\n", encrypted_pin_iv: "e4E99V82noXFLHhCfcWwBw==\n">
>> card.pin
=> "1234"
```

The encrypted `pin` dynamic attribute is backed by two database columns.
`encrypted_pin` and `encrypted_pin_iv`. You have to create them by a migration,
before using Claude.

The default secret used to encrypt an attribute with is `config.secret_token`
for Rails 3.2 and `secrets.secret_key_base` for Rails 4. You can use per
attribute secret or a different global one by setting `config.claude.secret` to
your likings. Changing it will invalidate all the current encryptions, so
beware of that.

## Contributing

1. Fork it ( https://github.com/gsamokovarov/claude/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
