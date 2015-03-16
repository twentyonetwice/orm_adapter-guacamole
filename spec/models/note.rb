# -*- encoding : utf-8 -*-

class Note
	include Guacamole::Model
	extend ActiveSupport::Autoload

	autoload :User, 'models/user'

	attribute :body, String
	attribute :user, User
end
