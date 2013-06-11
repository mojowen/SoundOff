if ENV['MANDRILL_APIKEY'] && ENV['MANDRILL_USERNAME']
	#  If Mandril is set up - use Mandril
	ActionMailer::Base.smtp_settings = {
	    :port =>           '587',
	    :address =>        'smtp.mandrillapp.com',
	    :user_name =>      ENV['MANDRILL_USERNAME'],
	    :password =>       ENV['MANDRILL_APIKEY'],
	    :domain =>         'soundoffatcongress.org',
	    :authentication => :plain
	}
	ActionMailer::Base.delivery_method = :smtp

elsif ENV['GMAIL_PASSWORD'] && ENV['GMAIL_USERNAME']


	ActionMailer::Base.smtp_settings = {
	  :address              => "smtp.gmail.com",
	  :port                 => 587,
	  :domain               => "soundoffatcongress.org",
	  :user_name            => ENV['GMAIL_USERNAME'],
	  :password             => ENV['GMAIL_PASSWORD'],
	  :authentication       => "plain",
	  :enable_starttls_auto => true
	}
end