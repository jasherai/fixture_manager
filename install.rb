# Install hook code here
require 'ftools'

cms_fixtures_path = File.join(File.dirname(__FILE__), "..", "..","..","cms","fixtures")
File.makedirs cms_fixtures_path

puts "\n"
puts IO.read(File.join(File.dirname(__FILE__), "README"))
puts "\n"