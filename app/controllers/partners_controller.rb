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
		@partners = Partner.all.reverse

		if params['format'] == 'csv'
			require 'csv'
			fields = ["name",'contact_name','contact_email','contact_phone',"website","tax_id","partner_type","created_at","mailing_address","privacy_policy","twitter_screen_name","hear_about_soundoff"]

			result = CSV.generate do |csv|
			  csv << ["Partner Name",'Contact Name','Contact Email','Contact Phone',"Partner Website","Tax ID","Partner Type","Created At","Mailing Address","Privacy Policy","Twitter Name","How Did You Hear About SoundOff"]

			  @partners.each do |partner|
				csv << fields.map{ |f| partner.send(f) }
			  end
			end

			send_data result, :type => 'text/csv; charset=utf-8; header=present', :disposition => "attachment; filename=all_partners.csv", :filename => "all_partners.csv"
		end
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