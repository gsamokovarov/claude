require 'test_helper'

module Claude
  class RailtieTest < ActiveSupport::TestCase
    test 'default secret is secret.secret_token' do
      new_uninitialized_app do |app|
        app.initialize!

        assert_equal app.secrets.secret_key_base, app.config.claude.secret
      end
    end

    test 'extends ActiveRecord::Base' do
      new_uninitialized_app do |app|
        app.initialize!

        assert_includes ActiveRecord::Base.singleton_class.ancestors, Extensions
      end
    end

    def new_uninitialized_app(root = File.expand_path('../../dummy', __FILE__))
      old_app = Rails.application

      FileUtils.mkdir_p(root)
      Dir.chdir(root) do
        Rails.application = nil

        app = Class.new(Rails::Application)
        app.config.eager_load = false
        app.config.time_zone = 'UTC'
        app.config.middleware ||= Rails::Configuration::MiddlewareStackProxy.new
        app.config.active_support.deprecation = :notify

        yield app
      end
    ensure
      Rails.application = old_app
    end
  end
end
