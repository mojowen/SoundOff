if ENV['SENDGRID_PASSWORD'] && ENV['SENDGRID_USERNAME']
	#  If Mandril is set up - use Mandril
	ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.sendgrid.net',
      :port           => '587',
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => 'soundoffatcongress.org',
      :enable_starttls_auto => true
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
Rails.application.routes.default_url_options[:host] =  ( ENV['BASE_DOMAIN'].gsub(/(https|http|\:\/\/)/,'') rescue 'localhost:3000' )
