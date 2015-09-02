class SensitiveWithCustomAttributes < ActiveRecord::Base
  self.table_name = "sensitives"

  attr_encrypt :message, attr: :a_message, attr_iv: :a_message_iv

  alias_attribute :a_message, :message
  alias_attribute :a_message_iv, :message_iv
end
