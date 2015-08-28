require 'test_helper'

module Claude
  class OpenSSLCipherBuilderTest < ActiveSupport::TestCase
    test "built ciphers can encrypt and decrypt in a full cycle" do
      secret = "foobar"

      cipher = new_cipher(:encrypt, key, iv)
      encrypted = cipher.update(secret) + cipher.final

      cipher = new_cipher(:decrypt, key, iv)
      decrypted = cipher.update(encrypted) + cipher.final

      assert_equal(secret, decrypted)
    end

    test "key and initialization vector can be nil" do
      assert_nothing_raised do
        new_cipher(:encrypt, nil, nil)
      end
    end

    test "initialization vector can be short" do
      short_iv = "1234"

      assert_nothing_raised do
        new_cipher(:encrypt, key, short_iv)
      end
    end

    def new_cipher(mode, key, iv)
      builder = OpenSSLCipherBuilder.new(key, iv)
      builder.build(mode)
    end

    def key
      "1234567890qwertyuiopasdfghjklzxcvbnm"
    end

    def iv
      "mnbvcxzxcvbnmmnbvcxz"
    end
  end
end
