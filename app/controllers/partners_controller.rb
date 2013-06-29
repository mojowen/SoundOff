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

	def index
	    redirect_to new_user_session_path unless current_user.admin

		@partners = Partner.all
	end

	def show
	    return redirect_to new_user_session_path unless current_user.admin
		redirect_to campaigns_path+'?partner='+params[:id]
	end

	def destroy
	    return redirect_to new_user_session_path unless current_user.admin
		Partner.find( params[:id] ).destroy
		redirect_to partners_path
	end

end