class JobDetailsController < ApplicationController

    before_action :check_user , only: [:create]
    before_action :authenticate_user!
    def check_user
        if current_user.role!='company'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def index
        if current_user.present? && current_user.role=='individual'
            @individual_applications=IndividualApplication.where(individual_id: current_user.individual.id )
            @accepted_individuals=AcceptedOffer.where(approval_type: 'IndividualApplication').and(AcceptedOffer.where(approval_id: @individual_applications))
            @job_results=JobDetail.where(accepted_offer_id: @accepted_individuals)
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    def create
        @jobdetail=JobDetail.new
        @jobdetail.accepted_offer_id=params[:accepted_offer_id]
        @jobdetail.result='SELECTED'
        if @jobdetail.save
            flash[:notice]='Selected successfully'
            redirect_to root_path
        else
            flash[:notice]=@jobdetail.errors
            redirect_to root_path
        end
    end
end
