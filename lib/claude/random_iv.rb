require 'claude'
require 'claude/openssl_cipher_builder'

module Claude
  class RandomIV
    # A shortcut for RandomIV.new(Claude.coder).generate.
    def self.generate
      new.generate
    end

    def initialize(coder = Claude.coder)
      @coder = coder
    end

    # Generates a secure random Initialization Vector that can be used for
    # OpenSSL encryption and decryption.
    #
    # It is encoded by a coder, so the IV consists of DB friendly characters.
    def generate
      coder.encode(cipher.random_iv)
    end

    private

    attr_reader :coder

    def cipher
      builder = OpenSSLCipherBuilder.new
      builder.build(:encrypt)
    end
  end
end
