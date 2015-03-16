require 'spec_helper'

describe Guacamole::Model::OrmAdapter do

	subject { Guacamole::Model::OrmAdapter.new(User) }

	describe 'AQL query should return the correct aql string ' do
		let(:conditions) { {:foo => 'bar'} }
		let(:more_conditions) { { :foo => 'bar', :rating => 42 } }
		let(:order) { [[:foo, :asc]] }
		let(:limit) { 1 }
		let(:offset) { 2 }


		it '(<conditions>)' do
			expect(subject.send(:extract_conditions!, conditions)).to eq [conditions, [], nil, nil]
		end

		it 'with conditions only' do
			expect(subject.send(:build_aql, :conditions => conditions)).to eq("FILTER user.foo == \"bar\"")
		end


		it 'with multiple conditions only' do
			expect(subject.send(:build_aql, :conditions => more_conditions)).to eq("FILTER user.foo == \"bar\" && user.rating == 42")
		end

		it '(:order => <order>)' do
			expect(subject.send(:extract_conditions!, :order => order)).to eq [{}, order, nil, nil]
		end

		it 'with order clause only' do
			expect(subject.send(:build_aql, :order => order)).to eq('SORT user.foo ASC')
		end

		it '(:limit => <limit>)' do
			expect(subject.send(:extract_conditions!, :limit => limit)).to eq [{}, [], limit, nil]
		end

		it 'with limit only' do
			expect(subject.send(:build_aql, :limit => limit)).to eq(' LIMIT 1')
		end

		it 'with order clause and limit' do
			expect(subject.send(:build_aql, :limit => limit, :order => order)).to eq('SORT user.foo ASC LIMIT 1')
		end

		it '(:offset => <offset>)' do
			expect(subject.send(:extract_conditions!, :offset => offset)).to eq [{}, [], nil, offset]
		end

		it 'with offset only' do
			expect(subject.send(:build_aql, :offset => offset)).to eq(' LIMIT 2, 2147483647')
		end

		it 'with order clause, limit and offset' do
			expect(subject.send(:build_aql, :limit => limit, :order => order, :offset => offset)).to eq('SORT user.foo ASC LIMIT 2, 1')
		end

		it '(:conditions => <conditions>, :order => <order>)' do
			expect(subject.send(:extract_conditions!, :conditions => conditions, :order => order)).to eq [conditions, order, nil, nil]
		end

		it 'with conditions and order clause' do
			expect(subject.send(:build_aql, :conditions => conditions, :order => order)).to eq("FILTER user.foo == \"bar\" SORT user.foo ASC")
		end

		it '(:conditions => <conditions>, :limit => <limit>)' do
			expect(subject.send(:extract_conditions!, :conditions => conditions, :limit => limit)).to eq [conditions, [], limit, nil]
		end

		it 'with conditions and limit' do
			expect(subject.send(:build_aql, :conditions => conditions, :limit => limit)).to eq("FILTER user.foo == \"bar\" LIMIT 1")
		end

		it '(:conditions => <conditions>, :offset => <offset>)' do
			expect(subject.send(:extract_conditions!, :conditions => conditions, :offset => offset)).to eq [conditions, [], nil, offset]
		end

		it 'with conditions and offset' do
			expect(subject.send(:build_aql, :conditions => conditions, :offset => offset)).to eq("FILTER user.foo == \"bar\" LIMIT 2, 2147483647")
		end

		describe '#valid_object?' do

			it 'determines whether an object is valid for the current model class' do
				expect(subject.send(:valid_object?, User.new)).to be_truthy
				expect(subject.send(:valid_object?, String.new)).to be_falsey
			end
		end

		describe '#normalize_order' do
			specify '(nil) returns []' do
				expect(subject.send(:normalize_order, nil)).to eq []
			end
			specify ':foo returns [[:foo, :asc]]' do
				expect(subject.send(:normalize_order, :foo)).to eq [[:foo, :asc]]
			end
			specify '[:foo] returns [[:foo, :asc]]' do
				expect(subject.send(:normalize_order, [:foo])).to eq [[:foo, :asc]]
			end
			specify '[:foo, :desc] returns [[:foo, :desc]]' do
				expect(subject.send(:normalize_order, [:foo, :desc])).to eq [[:foo, :desc]]
			end
			specify '[:foo, [:bar, :asc], [:baz, :desc], :bing] returns [[:foo, :asc], [:bar, :asc], [:baz, :desc], [:bing, :asc]]' do
				expect(subject.send(:normalize_order, [:foo, [:bar, :asc], [:baz, :desc], :bing])).to eq [[:foo, :asc], [:bar, :asc], [:baz, :desc], [:bing, :asc]]
			end
			specify '[[:foo, :wtf]] raises ArgumentError' do
				expect(lambda { subject.send(:normalize_order, [[:foo, :wtf]]) }).to raise_error(ArgumentError)
			end
			specify '[[:foo, :asc, :desc]] raises ArgumentError' do
				expect(lambda { subject.send(:normalize_order, [[:foo, :asc, :desc]]) }).to raise_error(ArgumentError)
			end
		end
	end

end
