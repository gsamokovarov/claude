require 'test_helper'

module Claude
  class IntegrationTest < ActiveSupport::TestCase
    test "automatic encryption and decryption by default" do
      sensitive = Sensitive.create(message: "Kisses!")
      sensitive.reload

      assert_equal "Kisses!", sensitive.message
    end

    test "encryption with per-attribute secret" do
      sensitive = SensitiveWithOwnSecret.create(message: "Shh! Its a secret!")
      sensitive.reload

      assert_equal "Shh! Its a secret!", sensitive.message
    end

    test "encryption with custom attributes" do
      sensitive = SensitiveWithOwnSecret.create(message: "The password is...")
      sensitive.reload

      assert_equal "The password is...", sensitive.message
    end
  end
end
