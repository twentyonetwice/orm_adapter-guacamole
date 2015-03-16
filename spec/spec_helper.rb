# -*- encoding : utf-8 -*-

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rspec'
require 'guacamole'
require 'orm_adapter'
require 'orm_adapter-guacamole'
require 'pry'
require 'models/note'
require 'models/user'
require 'edges/authorship'
require 'collections/notes_collection'
require 'collections/users_collection'


ENV['GUACAMOLE_ENV'] = 'test'

Guacamole.configure do |config|
	config.load File.join(File.dirname(__FILE__), 'config', 'guacamole.yml')
end

begin
	Guacamole.configuration.database.create
rescue Ashikawa::Core::ClientError
# Database already exists, don't worry
end

RSpec.configure do |config|
	config.expect_with :rspec do |c|
		c.syntax = :expect
	end
	config.mock_with :rspec do |c|
		c.syntax = :expect
	end
	config.before(:each) do
		Guacamole.configuration.database.truncate
	end
	config.after(:each) do
		Guacamole.configuration.database.truncate
	end
end
