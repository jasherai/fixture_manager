ActiveRecord::Base.send(:extend, FixtureManager::FixtureManagement)

unless RAILS_ENV=="test"
  require 'active_record/fixtures'
  Fixtures.send(:extend, FixtureManager::ManyToManyFixtureLoader)
end