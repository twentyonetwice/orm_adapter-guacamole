class NotesCollection
	include Guacamole::Collection

	map do
		attribute :user, via: Authorship, inverse: true
	end
end
