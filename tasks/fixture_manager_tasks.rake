namespace :cms do
  desc "Save the models defined in FixtureManager.fixture_classes to RAILS_ROOT/cms/fixtures"
  task :save_fixtures => [:environment] do
    FixtureManager.save_all
  end
  
  desc "Load the models defined in FixtureManager.fixture_classes to RAILS_ROOT/cms/fixtures"
  task :load_fixtures => [:environment] do
    FixtureManager.load_all
  end
end

namespace :test do
  desc "Save the models defined in FixtureManager.fixture_classes to RAILS_ROOT/test/fixtures"
  task :save_fixtures => [:environment] do
    FixtureManager.save_all(true)
  end
  
  desc "Load the models defined in FixtureManager.fixture_classes to RAILS_ROOT/test/fixtures"
  task :load_fixtures => [:environment] do
    FixtureManager.load_all(true)
  end
end