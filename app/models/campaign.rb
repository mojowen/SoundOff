class Campaign < ActiveRecord::Base
  attr_accessible :description, :hashtag, :name, :partner, :background,
  	:email_required, :end, :goal, :suggested

  serialize :suggested, JSON

  belongs_to :partner

  # has_many :tweets
  # has_many :emails

end
