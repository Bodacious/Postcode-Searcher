# frozen_string_literal: true

require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

# This is only to be used when updates are required. See README
# WebMock.allow_net_connect!
