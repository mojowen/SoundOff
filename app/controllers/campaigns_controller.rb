class CampaignsController < ApplicationController
	layout 'application.html'
	before_filter :only_logged_in

	def new
		@campaign = current_user.partner.campaigns.new
	end

	def create
		@campaign = Campaign.new( params[:campaign] )
		@campaign.partner = current_user.partner unless current_user.partner.nil?

		if @campaign.save
			redirect_to campaigns_path
		else
			render action 'new'
		end
	end

	def edit
		@campaign = Campaign.find( params[:id] )
		redirect_to root_path if ! current_user.admin && @campaign.partner != current_user.partner
	end

	def update
		@campaign = Campaign.find( params[:id] )
		redirect_to root_path if ! current_user.admin && @campaign.partner != current_user.partner

		@campaign.assign_attributes( params[:campaign] )

		if @campaign.save
			redirect_to campaigns_path
		else
			render action 'edit'
		end
	end

	def index
	end

	def show
	end

end