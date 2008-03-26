class Fixtures
  def self.create_many_to_many_fixtures(fixtures_directory, table_names)
    Dir[fixtures_directory+"/{#{table_names.join(",")}}.yml"].each do |yaml_file|
      table_name = File.basename(yaml_file).split(".").first
      
      ActiveRecord::Base.connection.execute("DELETE FROM #{table_name}")
      
      data = YAML.load_file(yaml_file)
      data.each do |entry|
        many_to_many_insert(entry, table_name)
      end
    end
  end
  
  def self.many_to_many_insert(hash, table)
    pairs = hash.to_a
    cols = pairs.collect(&:first).join(",")
    values = pairs.collect(&:last).join(",")
    
    ActiveRecord::Base.connection.execute("INSERT INTO #{table} (#{cols}) VALUES (#{values})")
  end
end