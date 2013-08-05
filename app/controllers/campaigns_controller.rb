class CampaignsController < ApplicationController
	layout 'application.html'
	before_filter :only_logged_in

	def index
		if current_user.admin
			unless params[:partner]
				@campaigns = Campaign.all( :order => 'created_at DESC' )
			else
				@partner = Partner.find(params[:partner])
				@campaigns = @partner.campaigns
			end
		else
			@campaigns = current_user.partner.campaigns
			@partner = current_user.partner
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

		@campaign.status = 'pending' unless current_user.admin

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
		filename = @campaign.name.downcase.gsub(' ','_').gsub(/[^0-9a-z|_]/i, '')
		require 'csv'

		if params[:export_names]
			soundoffs = current_user.admin ? Soundoff.find_all_by_campaign_id_and_headcount( @campaign.id.to_i ,true ) : Soundoff.find_all_by_campaign_id_and_partner( @campaign.id.to_i,true )

		    result = CSV.generate do |csv|
		      csv << [ "email", "message", "zip", "sent_date",'tweet link', "screen name"]
		      soundoffs.each do |soundoff|
		        csv << [soundoff.email,soundoff.message,soundoff.zip,soundoff.created_at,( "https://twitter.com/"+soundoff.twitter_screen_name+"/status/#{soundoff.tweet_id}" rescue '' ), soundoff.twitter_screen_name]
		      end
		    end

		    send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=#{filename}_emails.csv", :filename => "#{filename}_emails.csv"

		elsif params[:export_tweets]
			statuses = @campaign.all_tweets
		    result = CSV.generate do |csv|
		      csv << [ "screen name", "message", "tweet date",'tweet link', "hashtags","mentions"]
		      statuses.each do |soundoff|
		        csv << [soundoff.screen_name,soundoff.message,soundoff.tweet_date,("https://twitter.com/"+soundoff.screen_name+"/status/"+soundoff.tweet_id rescue ''),soundoff.data['entities']['hashtags'].map{|r| r['text'] }.join(', '), soundoff.data['entities']['user_mentions'].map{|r| r['screen_name'] }.join(', ')]
		      end
		    end

		    send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=#{filename}_tweets.csv", :filename => "#{filename}_tweets.csv"

		elsif params[:export_responses]
			statuses = @campaign.all_responses
		    result = CSV.generate do |csv|
		      csv << [ "screen name", "message", "tweet date",'tweet link', "hashtags","mentions"]
		      statuses.each do |soundoff|
		        csv << [soundoff.screen_name,soundoff.message,soundoff.tweet_date,("https://twitter.com/"+soundoff.screen_name+"/status/"+soundoff.tweet_id rescue ''),soundoff.data['entities']['hashtags'].map{|r| r['text'] }.join(', '), soundoff.data['entities']['user_mentions'].map{|r| r['screen_name'] }.join(', ')]
		      end
		    end

		    send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=#{filename}_responses.csv", :filename => "#{filename}_responses.csv"

		else
			render :template => 'campaigns/show'
		end
	end
	def destroy
		@campaign = Campaign.find( params[:id] )
		@campaign.destroy if current_user.admin
		render :json => { :success => true }
	end


end