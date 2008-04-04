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

      def get_many_to_many_association_config
        self.reflect_on_all_associations(:has_and_belongs_to_many).collect do |a| 
          {
            :primary_key_name => a.primary_key_name, 
            :association_foreign_key => a.association_foreign_key, 
            :join_table => a.options[:join_table]
          }
        end
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

          # write class yaml file
          write_yml(string, fixture_path, self.table_name, self.to_s.titleize)
          
          # gather many to many data
          association_infos = get_many_to_many_association_config

          association_infos.each do |association_info|
            data = self.connection.execute("select #{association_info[:primary_key_name]}, #{association_info[:association_foreign_key]} from #{association_info[:join_table]}")
            data.each do |h| 
              h.delete_if{|k, v| ![association_info[:primary_key_name], association_info[:association_foreign_key]].include?(k)}
            end
            
            # write many to many yaml
            write_yml(data.to_yaml, fixture_path, association_info[:join_table], association_info[:join_table])
          end
        end
        
        def write_yml(content, fixture_path, table_name, name)
          FileUtils.mkdir(fixture_path) unless File.exists?(fixture_path)
          FileUtils.mkdir("#{fixture_path}/fixtures") unless File.exists?("#{fixture_path}/fixtures")
          File.open(File.expand_path("#{fixture_path}/fixtures/#{table_name}.yml", RAILS_ROOT), 'w') do |out|  
            out.puts content
          end
          logger.info "Writing #{name} to #{fixture_path == "test" ? fixture_path.titleize : fixture_path.upcase} path"
        end
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
    end
  end
end

ActiveRecord::Base.class_eval do
  include ActiveRecord::FixtureManagement
end