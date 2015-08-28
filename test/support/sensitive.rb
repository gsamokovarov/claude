class Sensitive < ActiveRecord::Base
  self.table_name = "sensitives"

  attr_encrypt :message
end
