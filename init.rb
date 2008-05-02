require 'active_record/fixtures'

ActiveRecord::Base.send(:extend, FixtureManager::FixtureManagement)
Fixtures.send(:extend, FixtureManager::ManyToManyFixtureLoader)