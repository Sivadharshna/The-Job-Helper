module Api
    module V1
        class JobDetailsController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            
            before_action :check_permission

            def check_permission
                if current_user.role!='individual' && current_user.permission.status!='Permitted' 
                    render json: 'You need admins permssion to access', status: 403
                end
            end

            def index
                if current_user.present? && current_user.role=='individual'
                    @individual_applications=IndividualApplication.where(individual_id: current_user.individual.id )
                    @accepted_individuals=AcceptedOffer.where(approval_type: 'IndividualApplication').and(AcceptedOffer.where(approval_id: @individual_applications))
                    @job_results=JobDetail.where(accepted_offer_id: @accepted_individuals)
                    render json: @job_results, status: 200
                else
                    render json: 'Restricted Access', status: 403
                end
            end


            def create
                if current_user.present? && current_user.role=='company'
                    @jobdetail=JobDetail.new
                    @jobdetail.accepted_offer_id=params[:accepted_offer_id].to_i
                    @jobdetail.result='SELECTED'
                    if @jobdetail.save
                        render json:'Selected sucessfully', status: 200
                    else
                        render json: @jobdetail.errors , status: 422
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end

        end
    end
end

