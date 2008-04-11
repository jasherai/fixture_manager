unless RAILS_ENV == 'test'
  base_path = File.dirname(__FILE__) + "/lib/"
  require base_path + "fixture_manager" 
  require base_path + "active_record/fixture_management"
  require base_path + "active_record/many_to_many_fixtures"
end