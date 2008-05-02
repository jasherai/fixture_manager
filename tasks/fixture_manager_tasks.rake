namespace :cms do
  desc "Save the models defined in FixtureManager.fixture_classes to RAILS_ROOT/cms/fixtures"
  task :save_fixtures => [:environment] do
    if FixtureManager.save_all
      after_save
    else
      error!
    end
  end
  
  desc "Load the models defined in FixtureManager.fixture_classes to RAILS_ROOT/cms/fixtures"
  task :load_fixtures => [:environment] do
    unless FixtureManager.load_all
      error!
    end
  end
end

namespace :test do
  desc "Save the models defined in FixtureManager.fixture_classes to RAILS_ROOT/test/fixtures"
  task :save_fixtures => [:environment] do
    if FixtureManager.save_all(true)
      after_save
    else
      error!
    end
  end
  
  desc "Load the models defined in FixtureManager.fixture_classes to RAILS_ROOT/test/fixtures"
  task :load_fixtures => [:environment] do
    unless FixtureManager.load_all(true)
      error!
    end
  end
  
  def after_save
    begin
      Rake::Task[:annotate_models].invoke
    rescue Exception => e
      
    end
  end
  
  def error!
    puts "Please check the log, something has gone wrong!"
  end
end