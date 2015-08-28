require 'test_helper'

module Claude
  class RandomIVTest < ActiveSupport::TestCase
    test "can generate random initialization vectors" do
      assert_not_equal RandomIV.generate, RandomIV.generate
    end

    test "can use a coder to encode the initialization vector" do
      random_iv = RandomIV.new(FooCoder)

      assert_equal "foo", random_iv.generate
    end
  end
end
