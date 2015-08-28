require 'claude/openssl_cipher_builder'
require 'claude'

module Claude
  class Cipher
    class UnsupportedModeError < StandardError
      def initialize(mode)
        super("Unsupported mode #{mode}")
      end
    end

    class << self
      def for_encryption(key, iv)
        builder = OpenSSLCipherBuilder.new(key, iv)
        mode    = :encrypt

        new(builder.build(mode), mode)
      end

      def for_decryption(key, iv)
        builder = OpenSSLCipherBuilder.new(key, iv)
        mode    = :decrypt

        new(builder.build(mode), mode)
      end
    end

    def initialize(cipher, mode, coder = Claude.coder)
      @cipher = cipher
      @mode   = mode
      @coder  = coder
    end

    def encrypt(value)
      crypt(value)
    end

    def decrypt(value)
      crypt(value)
    end

    private

    attr_reader :cipher, :mode, :coder

    def crypt(value)
      case mode
      when :encrypt
        coder.encode(cipher.update(value) + cipher.final)
      when :decrypt
        cipher.update(coder.decode(value)) + cipher.final
      else
        raise UnsupportedModeError, mode
      end
    end
  end
end
