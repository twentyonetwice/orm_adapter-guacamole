# -*- encoding : utf-8 -*-

class User
	include Guacamole::Model
	extend ActiveSupport::Autoload

	autoload :Note, 'models/note'

	attribute :name, String
	attribute :rating, Integer
	attribute :notes, Array[Note]#, coerce: false
end
