class CampaignsController < ApplicationController
	layout 'application.html'
	before_filter :only_logged_in

	def index
		if current_user.admin
			@campaigns = Campaign.all.reverse
		else
			@campaigns = current_user.partner.campaigns.reverse
		end
	end

	def new
		if current_user.admin
			@campaign = Campaign.new
		else
			@campaign = current_user.partner.campaigns.new
		end
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

		if current_user.admin && params[:status] || ( current_user.partner == @campaign.partner && @campaign.status != 'pending')
			@campaign.status = params[:status]
		end

		if @campaign.save
			respond_to do |format|
				format.html { redirect_to campaigns_path }
				format.json { render :json => { :success => true } }
			end
		else
			respond_to do |format|
				render action 'edit'
				format.json { render :json => { :success => false } }
			end
		end
	end
	def show
		@campaign = Campaign.find( params[:id] )

		respond_to do |format|
			format.html
			format.text do
				if ! current_user.admin && ( @campaign.partner != current_user.partner || !@campaign.collect_email )
					result = ''
				else
					soundoffs = current_user.admin ? Soundoff.find_all_by_campaign_id_and_headcount( @campaign.id.to_i ,true ) : Soundoff.find_all_by_campaign_id_and_partner( @campaign.id.to_i,true )
					soundoffs = soundoffs.map do |soundoff|
						[
							soundoff.email,
							soundoff.zip,
							soundoff.targets,
							soundoff.tweet_id,
							soundoff.twitter_screen_name,
							soundoff.message
						].join("\t")
					end
					soundoffs.unshift(
						[
							"email",
							"zip",
							"targets",
							"tweet_id",
							"twitter_name",
							"message"
						].join("\t")
					)
					result =  soundoffs.join("\n")
				end
				render :inline => result
			end
		end
	end


end