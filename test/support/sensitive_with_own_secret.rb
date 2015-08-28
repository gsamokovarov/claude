class SensitiveWithOwnSecret < ActiveRecord::Base
  self.table_name = "sensitives"

  encrypt :message, secret: "qwertyuiop1234567890zxcvbnm0987654321"
end
