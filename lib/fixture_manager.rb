require 'active_record/fixtures'

class FixtureManager
  @@fixture_classes = []
  cattr_accessor :fixture_classes
  
  def self.save_all(test = false)
    RAILS_DEFAULT_LOGGER.info "Saving CMS data"

    @@fixture_classes.each do |klass|
      begin
        test ? klass.to_test_fixture : klass.to_cms_fixture
      rescue Exception => e
        RAILS_DEFAULT_LOGGER.error "Error saving: #{klass}"
        RAILS_DEFAULT_LOGGER.error e.message
        RAILS_DEFAULT_LOGGER.error e.backtrace.join("\n\t")
        return false
      end
    end

    RAILS_DEFAULT_LOGGER.info "All data saved"    
    return true
  end
  
  def self.load_all(test = false)
    RAILS_DEFAULT_LOGGER.info "Loading CMS data"
    begin
      fixture_path = File.join(RAILS_ROOT, "#{test ? "test" : "cms"}", "fixtures")
      
      tables = @@fixture_classes.collect{|klass| klass.table_name}
      Fixtures.create_fixtures(fixture_path, tables)
      
      tables = @@fixture_classes.collect{|klass| klass.get_many_to_many_association_config.collect{|a| a[:join_table]}}.flatten
      Fixtures.create_many_to_many_fixtures(fixture_path, tables)
    rescue => e
      RAILS_DEFAULT_LOGGER.error e.message
      RAILS_DEFAULT_LOGGER.error e.backtrace.join("\n\t")
      return false
    end
    
    RAILS_DEFAULT_LOGGER.info "All data loaded"
    return true
  end
end