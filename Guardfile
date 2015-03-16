# _*_ encoding : utf-8 _*_

guard :bundler do
	watch(/^.+\.gemspec/)
end

guard :rspec, cmd: 'rspec' do
	watch(%r{spec/.+\.rb})
	watch(%r{lib/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
	watch('spec/spec_helper.rb') { 'spec' }
end
