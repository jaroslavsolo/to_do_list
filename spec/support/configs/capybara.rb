# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.register_driver :chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    # This enables access to logs with `page.driver.manage.get_log(:browser)`
    loggingPrefs: {
      browser: 'ALL',
      client: 'ALL',
      driver: 'ALL',
      server: 'ALL'
    }
  )

  client = Selenium::WebDriver::Remote::Http::Default.new
  client.read_timeout = 90
  client.open_timeout = 90

  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('window-size=1240,1400')

  # Chrome won't work properly in a Docker container in sandbox mode
  options.add_argument('no-sandbox')

  # Run with browser
  options.add_argument('headless') unless ENV['CHROME_HEADLESS']&.match?(/^(false|no|0)$/i)

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    desired_capabilities: capabilities,
    options: options,
    http_client: client
  )
end

Capybara.javascript_driver = :chrome
Capybara.server = :puma, { Silent: true }
Capybara.default_max_wait_time = 5
