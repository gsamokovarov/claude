require 'claude/extensions'

module Claude
  class Railtie < ::Rails::Railtie
    config.claude = Claude

    initializer 'claude.active_record' do
      ActiveRecord::Base.send(:extend, Extensions)
    end

    initializer 'claude.default_secret' do |app|
      # Rails 3 keeps the default secret token Rails.application.config.
      if config.respond_to?(:secret_token)
        config.claude.secret ||= config.secret_token
      end

      # Rails 4 keeps them in Rails.application.secrets.
      if app.respond_to?(:secrets)
        config.claude.secret ||= app.secrets.secret_token || app.secrets.secret_key_base
      end
    end
  end
end
