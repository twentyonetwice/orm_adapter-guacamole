# -*- encoding : utf-8 -*-

require 'spec_helper'

if !defined?(Guacamole) || !(Guacamole.configuration.database.create rescue Ashikawa::Core::ClientError)
	puts "** require 'guacamole' and start ArangoDB to run the specs in #{__FILE__}"
else

	# Pure guacamole related specs!
	describe 'The collections' do

		let(:new_user) { User.new(name: 'Lou', rating: 99) }
		let(:new_note) { Note.new(body: 'Mambo No. 5') }

		it 'should create a user in the database' do
			UsersCollection.save new_user

			expect(UsersCollection.by_key(new_user.key)).to eq new_user
		end

		it 'should create a note in the database' do
			NotesCollection.save new_note

			expect(NotesCollection.by_key(new_note.key)).to eq new_note
		end

		it 'should create a relation between user and note' do
			UsersCollection.save new_user
			user = UsersCollection.by_key new_user.key
			user.notes = new_note
			UsersCollection.save user

			expect(user.notes.first.body).to eq('Mambo No. 5')
		end
	end

end
