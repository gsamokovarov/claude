require 'test_helper'

module Claude
  class CipherTest < ActiveSupport::TestCase
    test "ciphers can encrypt and decrypt" do
      cipher = Cipher.for_encryption(key, iv)
      encrypted = cipher.encrypt(secret)

      cipher = Cipher.for_decryption(key, iv)
      decrypted = cipher.decrypt(encrypted)

      assert_equal(secret, decrypted)
    end

    test "encodes the encryption result with an encoder" do
      builder = OpenSSLCipherBuilder.new(key, iv)

      cipher = Cipher.new(builder.build(:encrypt), :encrypt, FooCoder)
      encrypted = cipher.encrypt(secret)

      assert_equal("foo", encrypted)
    end

    test "decodes the encryption with a decoder" do
      builder = OpenSSLCipherBuilder.new(key, iv)

      cipher = Cipher.new(builder.build(:encrypt), :encrypt, IdCoder)
      encrypted = cipher.encrypt(secret)

      cipher = Cipher.new(builder.build(:decrypt), :decrypt, IdCoder)
      decrypted = cipher.decrypt(encrypted)

      assert_equal(secret, decrypted)
    end

    def key
      "1234567890qwertyuiopasdfghjklzxcvbnm"
    end

    def iv
      "mnbvcxzxcvbnmmnbvcxz"
    end

    def secret
      "foobar"
    end
  end
end
