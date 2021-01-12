# frozen_string_literal: true

# Don't load these when testing POROs
if defined?(Rails)
  require 'shoulda-matchers'
  require 'shoulda-context'

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
