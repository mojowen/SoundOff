class CampaignMail < ActionMailer::Base
  default from: "info@soundoffatcongress.org"

  def new_campaign(campaign)
  	@campaign = campaign
  	puts 'sending email'
  	mail(:to => 'srduncombe@gmail.com', :subject => "#{campaign.partner.name} Just Submitted #{campaign.name}")
  end
  def campaign_approved(campaign)
  	@campaign = campaign
  	# @campaign.partner.users.first.email
  	mail(:to => 'srduncombe@gmail.com', :subject => "#{campaign.partner.name} - #{@campaign.name} Was Just Approved")
  end

end
