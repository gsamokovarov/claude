require 'claude/version'
require 'claude/coder'
require 'claude/railtie'

module Claude
  # Used to encrypt and decrypt attributes with.
  mattr_accessor :secret

  # The OpenSSL::Cipher used for the encryption.
  mattr_accessor :ssl_cipher
  self.ssl_cipher = 'AES-256-CBC'

  # The coder is used to encode decode the keys and ivs to DB string column
  # friendly characters. Base64 encoding by default.
  mattr_accessor :coder
  self.coder = Coder
end

