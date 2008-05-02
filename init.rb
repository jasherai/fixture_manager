# # if ['development', 'qa'].include?(RAILS_ENV)
#   base_path = File.dirname(__FILE__) + "/lib/"
#   require base_path + "fixture_manager" 
#   require base_path + "active_record/fixture_management"
#   require base_path + "active_record/many_to_many_fixtures"
# # end

require 'active_record/fixtures'

ActiveRecord::Base.send(:extend, FixtureManager::FixtureManagement)
Fixtures.send(:extend, FixtureManager::ManyToManyFixtureLoader)