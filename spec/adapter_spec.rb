# -*- encoding : utf-8 -*-

require 'spec_helper'
require 'example_app_shared'

describe Guacamole::Model::OrmAdapter do

	it_should_behave_like 'example app with orm_adapter' do

		let(:user_class) { User }
		let(:note_class) { Note }

	end
end
