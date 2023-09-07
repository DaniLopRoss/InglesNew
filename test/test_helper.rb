require 'simplecov'
SimpleCov.start 'rails' do
  # add_filter '/test/'
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Helpers", "app/helpers"
  
end
# SimpleCov.coverage_dir 'coverage/custom_folder_name'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'

Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Add your customizations here
  # def teardown
  #   SimpleCov.result.format!
  # end
end

