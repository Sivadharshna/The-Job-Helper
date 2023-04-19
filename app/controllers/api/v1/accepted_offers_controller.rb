module Api
    module V1
        class AcceptedOffersController < Api::ApplicationController
            before_action :doorkeeper_authorize!

            ###############################################
            

            ##########################################
            def index
                if current_user.role=='company'
                    private ch1=0,ch2=0
                    @jobs=Job.where(company_id: params[:company_id])
                    @individual_applications=IndividualApplication.where(job_id: @jobs)
                    sql1='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE companies.id='+params[:company_id].to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                    #sql1 = "INNER JOIN individual_applications ON individual_applications.id = accepted_offers.approval_id INNER JOIN jobs ON jobs.id = individual_applications.job_id WHERE company_id="+ params[:company_id].to_s
                    #@accepted_individuals=AcceptedOffer.joins(sql1).load
                    if @accepted_individuals
                        ch1=1
                        render json: @accepted_individuals, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                    sql2='select colleges.name as College, companies.name as Company, accepted_offers.schedule FROM accepted_offers INNER JOIN college_applications ON college_applications.id=accepted_offers.approval_id INNER JOIN colleges ON colleges.id=college_applications.id INNER JOIN companies ON college_applications.company_id=companies.id WHERE companies.id='+params[:company_id].to_s
                    @accepted_colleges=AcceptedOffer.connection.select_all(sql2)
                    #sql2="INNER JOIN college_applications ON college_applications.id = accepted_offers.approval_id WHERE company_id = "+params[:company_id].to_s
                    #@accepted_colleges=AcceptedOffer.joins(sql2).load
                    if @accepted_colleges
                        ch2=1
                        render json: @accepted_colleges, status: 200
                    else
                        render json: 'No College Applications found', status: 404
                    end

                    if ch1==0 && ch2==0
                        render json: 'No applications found' , status: 404
                    end
                elsif current_user.role=='individual'
                    sql='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE individuals.id='+params[:individual_id].to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                    if @accepted_individuals
                        render json: @accepted_individuals, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                end


            end

            def create
                @accepted_offer=AcceptedOffer.new(accepted_params)
                if params[:application_type]=='college_applications'
                    @accepted_offer.approval_type='CollegeApplication'
                elsif params[:application_type]=='individual_applications'
                    @accepted_offer.approval_type='IndividualApplication'
                end
                @accepted_offer.approval_id=params[:application_id]
                if @accepted_offer.save
                    render json: @accepted_offer, status: 200
                else
                    render json: @accepted_offer.errors, status: 412
                end   
            end

            private def accepted_params
                params.permit(:schedule)
            end
        end
    end
end

