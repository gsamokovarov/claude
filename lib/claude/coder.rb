module Claude
  # The coder interface is implemented by any object responding to #encode and
  # #decode.
  #
  # The current implementation defaults to Base64 encoding and decoding as the
  # characters are friendly for RDBMS string types.
  module Coder
    extend self

    def encode(value)
      Base64.encode64(value)
    end

    def decode(value)
      Base64.decode64(value)
    end
  end
end
