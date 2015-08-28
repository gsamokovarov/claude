class CreateSensitive < ActiveRecord::Migration
  def change
    create_table :sensitives do |t|
      t.string :encrypted_message
      t.string :encrypted_message_iv
    end
  end
end
