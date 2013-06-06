class PartnersController < ApplicationController
	layout 'application.html'

	def new
		redirect_to campaigns_path unless !!! current_user
		@partner = Partner.new
		@partner.users.new( params[:account] ) if params[:account]
	end

	def create
		@partner = Partner.new( params[:partner] )

		if @partner.save
			sign_in @partner.users.first
			redirect_to new_campaign_path
		else
			render action: 'new'
		end
	end

end