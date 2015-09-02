require 'claude/random_iv'
require 'claude/cipher'

module Claude
  module Extensions
    # Encrypt the value stored at attr when persisting the value in the
    # underlying database.
    #
    # To encrypt an attr we need to have two extra columns named:
    #
    #   * encrypted_attr    - Used internally to store the encrypted value.
    #   * encrypted_attr_iv - Used internally to encrypt the value above.
    #
    # Note that attr is dynamic here. If you wanna encrypt the attribute pin:
    #
    #   class Card < ActiveRecord::Base
    #     encrypt :pin
    #   end
    #
    # The expected columns will be named encrypted_pin and encrypted_pin_iv.
    #
    # Encrypt will generate two new instance methods: attr and attr=. Those
    # are dynamic and compute its value based of encrypted_attr and
    # decrypted_attr.
    #
    # attr decrypt the value from the encrypted_attr.
    # attr= encrypts the value that is passed to it and saves it to encrypted_attr.
    #
    # Most of the time, you won't need to call encrypted_attr and
    # encrypted_attr_iv manually. Consider them an implementation detail.
    #
    # You can pass the following options:
    #
    #   * :attr    - The name of the internal encrypted column.
    #                Defaults to "encrypted_#{attr}".)
    #
    #   * :attr_iv - The name of the internal initialization vector column.
    #                Defaults to "encrypted_#{attr}_iv".
    #
    #   * :secret  - The secret used to encrypt the attribute.
    #                Defaults to config.secret_roken or config.secrets.secret_token.
    def encrypt(attr, options = {})
      attr_secret   = options.fetch(:secret, Claude.secret).inspect
      attr_internal = options.fetch(:attr, "encrypted_#{attr}")
      attr_iv       = options.fetch(:attr_iv, "encrypted_#{attr}_iv")
      attr_raw      = "#{attr_internal}_before_type_cast"

      module_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{attr}
          return unless #{attr_raw}

          cipher = Cipher.for_decryption(#{attr_secret}, #{attr_iv})
          cipher.decrypt(#{attr_raw})
        end

        def #{attr}=(value)
          if value
            iv     = RandomIV.generate
            cipher = Cipher.for_encryption(#{attr_secret}, iv)

            self.#{attr_iv}       = iv
            self.#{attr_internal} = cipher.encrypt(value)
          else
            self.#{attr_iv}       = nil
            self.#{attr_internal} = nil
          end
        end
      RUBY
    end

    alias encrypt_attribute encrypt

    # An alias to encrypt that lets you encrypt multiple attributes at once.
    #
    # If only one attribute is given, it acts exactly like encrypt does.
    #
    # When multiple attributes are given, you can still give options. However,
    # the :attr and :attr_iv options will be the same for all the attributes.
    #
    #   class Card < ActiveRecord::Base
    #     attr_encrypt :pin, :pan
    #   end
    def attr_encrypt(*attrs)
      options = attrs.extract_options!

      attrs.each do |attr|
        encrypt attr, options
      end
    end

    alias encrypt_attributes attr_encrypt
  end
end
