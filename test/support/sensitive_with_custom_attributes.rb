class SensitiveWithCustomAttributes < ActiveRecord::Base
  self.table_name = "sensitives"

  attr_encrypt :message, attr: :a_message, attr_iv: :a_message_iv

  # We can't alias those, as by the time we do, they are still not inferred and
  # defined.
  def a_message
    encrypted_message
  end

  def a_message=(value)
    self.encrypted_message = value
  end

  def a_message_iv
    encrypted_message_iv
  end

  def a_message_iv=(value)
    self.encrypted_message_iv = value
  end
end
