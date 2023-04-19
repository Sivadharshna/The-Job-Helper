class JobDetailsController < ApplicationController

    before_action :check_user , only: [:create]

    def check_user
        if current_user.role!='company'
            flash[:notice]='Restricted Access'
            redirect_to request.referer
        end
    end


    def create
        @jobdetail=JobDetail.new
        @jobdetail.accepted_offer_id=params[:accepted_offer_id]
        @jobdetail.result='SELECTED'
        if @jobdetail.save
            flash[:notice]='Selected sucessfully'
            redirect_to request.referer
        else
            flash[:notice]=@jobdetail.errors
            redirect_to request.referer
        end
    end
end
