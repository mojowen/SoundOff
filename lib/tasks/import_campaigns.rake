partners = <<EOF
info@savethechildrenactionnetwork.org	202.640.6600	2000 L Street NW, Suite 500, Washington, DC 20036	SCActionNetwork	Save the Children	http://i.imgur.com/3tD5eLy.jpg	http://www.savethechildrenactionnetwork.org	http://www.savethechildrenactionnetwork.org/site/c.csIRI8NIK9KYF/b.9171537/k.A063/Privacy_Policy.htm	Urge your senators to prioritize funding for maternal and child health programs
info@ajws.org	212.792.2900	45 West 36th Street New York, NY 10018	ajws	AJWS	http://i.imgur.com/0RqTPog.jpg	http://ajws.org/​	http://ajws.org/privacy_policy.html	Tell your senators not to cut critical funding for women and girls worldwide in the budget|Fighting violence against women and girls is smart, cutting aid to them is not|Investing in women and girls pays off, don’t cut aid for gender programs
info@worldvision.org	1-888-511-6548	P.O. Box 9716 Federal Way, WA 98063	WorldVisionUSA	World Vision	http://i.imgur.com/CreXwsS.png	http://beyond5.org/?Open=&campaign=127606110	http://www.worldvision.org/privacy-policy	Ask your Senators not to cut the less than 1% of the budget that saves lives
info@bread.org	(202) 639-9400	425 3rd Street SW, Suite 1200 Washington, DC 20024	bread4theworld	Bread for the World	http://i.imgur.com/erkOtIC.png	http://www.bread.org/	http://www.bread.org/about-us/privacy-policy.html	Tell your senators: Help save lives. Don’t cut international or U.S. anti-hunger and anti-poverty programs
EOF

hashtag = "AidSavesLives"
campaign_name = hashtag
target = "senate"
description = "Foreign Aid saves lives"

task :import_campaigns => :environment  do
	partners.split("\n").each do |raw|
		partner = raw.split("\t")
		email = partner.shift()
		phone = partner.shift()
		address = partner.shift()
		twitter = partner.shift()
		partner_name = partner.shift()
		logo = partner.shift()
		website = partner.shift()
		privacy_policy = partner.shift()
		prepopulated = partner.shift()

		custom_style = <<EOF
form.stage_1::before, form.stage_2::before {
  content: '';
  background: transparent url('#{logo}') top left no-repeat;
  display: block;
  position: absolute;
  top: 71px;
  width: 48px;
  height: 48px;
  background-size: contain;
  left: 41px;
}
form img {
	&.stage_1, &.stage_2 {
		float: right;
	}
}
@media (max-width: 540px) {
    #popup::after, #popup::before {
    	top: 0px;
    }
    form.stage_1::before, form.stage_2::before {
      top: 40px;
    }
}
EOF

		prepopulated = prepopulated.split('|')

		partner = Partner.new(
			:twitter_screen_name => twitter,
			:contact_phone => phone,
			:mailing_address => address,
			:tax_id => partner_name,
			:contact_name => partner_name,
			:name => partner_name,
			:custom_popup_css => custom_style,
			:privacy_policy => privacy_policy,
			:website => website,
			:contact_password => hashtag,
			:contact_email => email,
			:partner_type => 'nonprofit'
		)
		unless partner.save()
			puts partner.errors.to_h
		else
			campaign = Campaign.new(
				:name => campaign_name,
				:hashtag => hashtag,
				:description => description,
				:target => target,
				:suggested => prepopulated,
			)
			campaign.partner_id = partner.id
			campaign.save()
			campaign.status = 'approved'
			campaign.save()
			puts "#{partner.name} saved with #{campaign.id}"
		end

	end
end