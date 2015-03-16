class Authorship
	include Guacamole::Edge

	from :users
	to   :notes
end
