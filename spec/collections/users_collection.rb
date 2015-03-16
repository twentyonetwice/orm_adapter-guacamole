class UsersCollection
	include Guacamole::Collection

	map do
		attribute :notes, via: Authorship
	end
end
