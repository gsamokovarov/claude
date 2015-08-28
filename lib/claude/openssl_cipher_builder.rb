require 'openssl'
require 'digest'
require 'claude'

module Claude
  class OpenSSLCipherBuilder
    def initialize(key = nil, iv = nil, ssl_cipher = Claude.ssl_cipher)
      @key        = key && key.to_s
      @iv         = hash_if_too_short(iv)
      @ssl_cipher = ssl_cipher
    end

    def build(mode)
      OpenSSL::Cipher.new(ssl_cipher).tap do |cipher|
        cipher.public_send(mode)

        cipher.key = key if key
        cipher.iv  = iv  if iv
      end
    end

    private

    attr_reader :key, :iv, :ssl_cipher

    # When passing a custom IV column, it can be too short for OpenSSL to work
    # with. Make sure it isn't.
    def hash_if_too_short(iv)
      return if iv.nil?
      iv.size < 16 ? Digest::SHA1.hexdigest(iv.to_s) : iv.to_s
    end
  end
end
