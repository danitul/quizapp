ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/autorun"
require "minitest/rails"
require 'minitest/test'
require 'webmock/minitest'

class Minitest::Unit::TestCase
  include FactoryBot::Syntax::Methods
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # This unfortunately does not work on my WSL (linux on windows) machine for the time being.
  #parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods
end
