class Option < ActiveRecord::Base
	attr_accessible :name, :data
	serialize :data, JSON
end