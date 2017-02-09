class Campaign < ActiveRecord::Base
  attr_accessible :description, :hashtag, :name, :partner, :background,
    :email_option, :end, :goal, :suggested, :target

  serialize :suggested, JSON

  belongs_to :partner

  before_save :fix_suggested, :fix_short_url, :notify_pending, :notify_active, :check_hashtag
  def fix_suggested
    if suggested.class == Hash
      self.suggested = self.suggested.map{ |k,v| v }.reject{ |l| l.empty? }
    end
  end
  def fix_short_url
    self.short_url = SecureRandom.urlsafe_base64( 3, false) if short_url.nil?
  end
  def check_hashtag
    throw "That Hashtag wont work sport" if ['soundoff'].index( hashtag.downcase )
  end
  def notify_pending
    CampaignMail.new_campaign( self ).deliver if ! self.partner.nil? && self.status == 'pending'
  end
  def notify_active
    CampaignMail.campaign_approved( self ).deliver if ! self.partner.nil? && self.status == 'approved' && status_changed?
  end

  # Normal methods
  def url
    (ENV['BASE_DOMAIN'] || '') + '/' + self.short_url
  end
  def collect_email
    return false if email_option == 'hidden'
    if partner.nil?
      return true
    else
      return partner.partner_type == 'nonprofit'
    end
  end
  def score(pre_score=nil)
    return 0 if self.hashtag.nil?

    if pre_score
      pre_score[self.hashtag.downcase] || 0
    else
      hashtag = Hashtag.find_by_keyword(self.hashtag.downcase)
      hashtag ? hashtag.statuses.count : 0
    end
  end

  def sample_tweets
    tweets = []
    sample_hashtags = "#SoundOff ##{hashtag}"
    sample_status = Status.all( :limit => 4, :offset => rand( Status.count -4 ), :conditions => ['reply_to IS NULL'] )

    num = 0
    self.suggested.each do |k,suggestion|
      if suggestion.nil?
        suggestion = k
        k = num
        num = k + 1
      end

      if suggestion.class == String && suggestion.length > 1
        sample = sample_status.shift
        sample.message = "#{suggestion} #{sample_hashtags}"
        tweets.push sample
      end
    end

    (4 - tweets.length).times do
      tweets.push sample_status.shift
      tweets.last.message += " ##{hashtag}"
    end

    return tweets
  end

  def to_obj(pre_score=nil)
    return {
      :name => name,
      :score => score(pre_score),
      :description => description,
      :id => id,
      :hashtag => '#'+hashtag,
      :partner => (partner.name rescue nil),
      :twitter_name => ( (partner.twitter_screen_name.nil? ? '' : '@'+partner.twitter_screen_name) rescue '@HeadCountOrg' ),
      :twitter_profile => ( (partner.twitter_screen_name.nil? ? '' : 'http://twitter.com/'+partner.twitter_screen_name) rescue 'http://twitter.com/headcountorg' ),
      :logo => ( (partner.logo.empty? ? '/assets/sq_icon.jpg' : partner.logo) rescue '/assets/sq_icon.jpg'  ),
      :website => (partner.website rescue nil),
      :tweets => [],
      :created_at => created_at,
      :short_url => short_url,
      :target => (self.target == 'house' ? 'House Rep' : self.target == 'senate' ? 'Senator' : 'Senators and House Rep' )
    }
  end
  def self.active
    where('status = ? AND updated_at > ?', 'approved', 6.months.ago)
      .order(:id)
      .includes(:partner)
      .each_with_object({}) do |campaign, obj|
        obj[campaign.hashtag] = campaign
        obj
      end.values
  end
  def self.active_to_objs(injected_campaign = nil)
    active_campaigns << injected_campaign if injected_campaign
    pre_score = Hash[ Hashtag.joins('INNER JOIN "hashtags_statuses" ON "hashtags_statuses"."hashtag_id" = "hashtags"."id"')
                             .select('COUNT(hashtags_statuses.status_id), keyword')
                             .where(['keyword IN (?)', active_campaigns.map(&:hashtag).map(&:downcase)])
                             .group('keyword')
                             .to_a
                             .map{ |hashtag| [hashtag.keyword, hashtag.count.to_i] } ]
    active_campaigns.map{ |campaign| campaign.to_obj(pre_score) }
  end
  def updated
    if last_soundoff = Soundoff.all( :limit => 1, :conditions => { :campaign_id => id}, :order => 'created_at DESC' ).first
      return last_soundoff.created_at
    else
      return updated_at
    end
  end
  def all_tweets
    hashtag = Hashtag.find_by_keyword(self.hashtag.downcase)
    hashtag ? hashtag.statuses.reverse_order : []
  end
  def all_responses
    hashtag = Hashtag.find_by_keyword(self.hashtag.downcase)
    hashtag ?  hashtag.statuses.where('reply_to IS NOT NULL').reverse_order : []
  end
  def count_tweets
    hashtag = Hashtag.find_by_keyword(self.hashtag.downcase)
    hashtag ? hashtag.statuses.count : 0
  end
  def count_responses
    hashtag = Hashtag.find_by_keyword(self.hashtag.downcase)
    hashtag ? hashtag.statuses.where('reply_to IS NOT NULL').count : 0
  end
  def count_signups
    Soundoff.count( :conditions => ['partner IS TRUE AND campaign_id = ?',self.id] )
  end

end
