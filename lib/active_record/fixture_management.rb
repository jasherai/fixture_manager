# http://rails.techno-weenie.net/tip/2005/12/23/make_fixtures
module ActiveRecord
  module FixtureManagement
    module ClassMethods
      # Write a fixture file for testing
      def to_test_fixture
        write_fixture_file("test")
      end

      # Write a fixture file for the CMS system
      def to_cms_fixture
        write_fixture_file("cms")
      end

      private
        def write_fixture_file(fixture_path)
          raise "fixture_path cannot be blank!" if fixture_path.blank?

          # collect the data in an array to preserve ordering by id
          data = find(:all, :order => :id).inject([]) do |array, record|
            array << {record.id => record.attributes(:except => [:created_at, :updated_at])} 
          end

          # add !omap to the YAML header
          string = YAML.dump data
          string = string[0..3] + "!omap" + string[4..-1]

          File.open(File.expand_path("#{fixture_path}/fixtures/#{table_name}.yml", RAILS_ROOT), 'w') do |out|  
            out.puts string
          end
          logger.info "Writing #{self.to_s.titleize} to #{fixture_path == "test" ? fixture_path.titleize : fixture_path.upcase} path"
        end
    end
    
    module InstanceMethods
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end

ActiveRecord::Base.class_eval do
  include ActiveRecord::FixtureManagement
end