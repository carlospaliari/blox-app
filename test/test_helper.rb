ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __FILE__)
load Rails.root.join("db", "schema.rb")
require "rails/test_help"
# ActiveRecord::Base.logger = Logger.new(STDOUT)

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
