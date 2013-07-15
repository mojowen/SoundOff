class Hashtag < ActiveRecord::Base
  attr_accessible :keyword
  has_and_belongs_to_many :statuses
  validates_uniqueness_of :keyword
end
