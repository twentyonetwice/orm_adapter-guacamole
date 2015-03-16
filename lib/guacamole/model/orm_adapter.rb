# -*- encoding : utf-8 -*-

require 'guacamole'
require 'orm_adapter'

module Guacamole
	module Model
		module ClassMethods
			include ::OrmAdapter::ToAdapter
		end

		class OrmAdapter < ::OrmAdapter::Base
			extend Forwardable

			def self.model_classes
				Guacamole::Model.all
			end

			# creates the name of the collection from the klass name
			def collection_name
				"#{klass.model_name.to_s.classify.pluralize}Collection".constantize
			end

			# @see OrmAdapter::Base#get!
			def get!(id)
				collection_name.by_key(wrap_key(id))
			end

			# @see OrmAdapter::Base#get
			def get(id)
				begin
					collection_name.by_key(wrap_key(id))
				rescue URI::InvalidURIError, Ashikawa::Core::DocumentNotFoundException
					return nil
				end
			end

			# @see OrmAdapter::Base#find_first
			def find_first(options = {})
				collection_name.by_aql(build_aql(options)).to_a.first
			end

			# @see OrmAdapter::Base#find_all
			def find_all(options = {})
				collection_name.by_aql(build_aql(options)).to_a
			end

			# @see OrmAdapter::Base#create
			def create!(attributes = {})
				model = klass.new(attributes)
				collection_name.create model
			end

			# @see OrmAdapter::Base#destroy
			def destroy(object)
				collection_name.delete(object) && true if valid_object?(object)
			end

			protected

			def wrap_key(key)
				key.is_a?(Array) ? key.first : key
			end

			def build_aql(conditions)
				conditions, order, limit, offset = extract_conditions!(conditions)
				conditions = conditions_to_fields(conditions)
				unless conditions.empty?
					aql_string = "FILTER " << conditions.map{|k, v| "user.#{k} == #{v.inspect}"}.join(" && ")
					unless order.empty?
						order_str =[]
						order.each do |attr, direction|
							order_str << "#{klass.model_name.element}.#{attr} #{direction.upcase}"
						end
						aql_string << " SORT #{order_str.join(', ')}"
					end
						aql_string << " LIMIT #{limit}" unless limit.nil?
						# cause AQL has no single offset method, using the LIMIT 42, 2147483647 is just a workaround
						# (42 would be the offset, 2147483647 is a just a high number for the tests )
						aql_string << " LIMIT #{offset}, 2147483647" unless offset.nil?
				else
					unless order.empty?
						aql_string = 'SORT '
						order_str =[]
						order.each do |attr, direction|
							order_str << "#{klass.model_name.element}.#{attr} #{direction.upcase}"
						end
						aql_string << order_str.join(', ')
						if !limit.nil? && !offset.nil?
							aql_string << " LIMIT #{offset}, #{limit}" unless limit.nil?
						elsif !limit.nil? && offset.nil?
							aql_string << " LIMIT #{limit}"
						elsif limit.nil? && !offset.nil?
							aql_string << " LIMIT #{offset}, 2147483647"
						end
					else
						if !limit.nil? && !offset.nil?
							aql_string = " LIMIT #{offset}, #{limit}" unless limit.nil?
						elsif !limit.nil? && offset.nil?
							aql_string = " LIMIT #{limit}"
						elsif limit.nil? && !offset.nil?
							aql_string = " LIMIT #{offset}, 2147483647"
						end
					end
				end
				aql_string
			end

			# given an options hash,
			# with optional :conditions, :order, :limit and :offset keys,
			# returns conditions, normalized order, limit and offset
			def extract_conditions!(options = {})
				order = normalize_order(options.delete(:order))
				limit = options.delete(:limit)
				offset = options.delete(:offset)
				conditions = options.delete(:conditions) || options
				[conditions, order, limit, offset]
			end

			# given an order argument, returns an array of pairs, with each pair containing the attribute, and :asc or :desc
			def normalize_order(order)
				order = Array(order)
				if order.length == 2 && !order[0].is_a?(Array) && [:asc, :desc].include?(order[1])
					order = [order]
				else
					order = order.map {|pair| pair.is_a?(Array) ? pair : [pair, :asc] }
				end
				order.each do |pair|
					pair.length == 2 or raise ArgumentError, "each order clause must be a pair (unknown clause #{pair.inspect})"
					[:asc, :desc].include?(pair[1]) or raise ArgumentError, "order must be specified with :asc or :desc (unknown key #{pair[1].inspect})"
				end
				order
			end

			# converts and documents to ids
			def conditions_to_fields(conditions)
				conditions.inject({}) do |fields, (key, value)|
					if key.to_s == 'id'
						fields.merge('_key' => value)
					else
						fields.merge(key => value)
					end
				end
			end

		end
	end
end
