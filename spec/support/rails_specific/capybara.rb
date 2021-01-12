# frozen_string_literal: true

require 'webdrivers/chromedriver'
require 'capybara/rspec'

Capybara.server = :puma, { Silent: true } # To clean up your test output
Capybara.asset_host = 'http://localhost:3000'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, js: true) do
    # driven_by :selenium_chrome
    driven_by :selenium_chrome_headless, screen_size: [1920, 1080]
  end
end
Capybara.configure do |config|
  config.default_max_wait_time = 5 # seconds
end
