class CampaignMail < ActionMailer::Base
  default from: "SoundOff@HeadCount.org"

  def new_campaign(campaign)
  	@campaign = campaign
  	mail(:to => 'SoundOff@HeadCount.org', :subject => "#{campaign.partner.name} Just Submitted #{campaign.name}")
  end
  def campaign_approved(campaign)
  	@campaign = campaign
  	mail(:to => @campaign.partner.users.first.email, :subject => "#{campaign.partner.name} - #{@campaign.name} Was Just Approved")
  end

end
