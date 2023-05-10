module Api
    module V1
        class AcceptedOffersController < Api::ApplicationController
            before_action :doorkeeper_authorize!

            
            before_action :check_user, only: [:new, :create]

            def check_user
                if current_user.present? && current_user.role!='company'
                    render json: 'Restricted Access', status: 403
                end
            end


            def index
                if current_user.role=='company'
                    @jobs=Job.where(company_id: params[:company_id])
                    ch1=0
                    ch2=0
                    @individual_applications=IndividualApplication.where(job_id: @jobs)
                    sql1='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE companies.id='+current_user.company.id.to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                    sql2='select colleges.name as College, companies.name as Company, accepted_offers.schedule FROM accepted_offers INNER JOIN college_applications ON college_applications.id=accepted_offers.approval_id INNER JOIN colleges ON colleges.id=college_applications.id INNER JOIN companies ON college_applications.company_id=companies.id WHERE companies.id='+current_user.company.id.to_s
                    @accepted_colleges=AcceptedOffer.connection.select_all(sql2)
                    if @accepted_colleges || @accepted_individuals
                        render json: { colleges: @accepted_colleges, individuals: @accepted_individuals }, status: 200
                    else
                        render json: 'No applications found' , status: 404
                    end
                elsif current_user.role=='individual'
                    sql='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE individuals.id='+current_user.individual.id.to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql)
                    if @accepted_individuals
                        render json: @accepted_individuals, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                elsif current_user.role=='college'
                    sql='select colleges.name as College, companies.name as Company, accepted_offers.schedule FROM accepted_offers INNER JOIN college_applications ON college_applications.id=accepted_offers.approval_id INNER JOIN colleges ON colleges.id=college_applications.id INNER JOIN companies ON college_applications.company_id=companies.id WHERE colleges.id='+current_user.college.id.to_s
                    @accepted_colleges=AcceptedOffer.connection.select_all(sql)
                    if @accepted_colleges
                        render json: @accepted_colleges, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                end
            end

            def create
                @accepted_offer=AcceptedOffer.new(accepted_params)
                if params[:approval_type]=='individual_applications'
                    @individual_application=IndividualApplication.find(params[:approval_id])
                    @accepted_offer.approval=@individual_application
                elsif params[:approval_type]='college_applications'
                    @college_application=CollegeApplication.find(params[:approval_id])
                    @accepted_offer.approval=@college_application
                end
                if @accepted_offer.save
                    if @accepted_offer.approval_type=='IndividualApplication'
                        @individual_application.update(status: 'Approved')
                    elsif @accepted_offer.approval_type=='CollegeApplication'
                        @college_application.update(status: 'Approved')
                    end
                    render json: 'Saved Successfully', status: 200
                else
                    if @accepted_offer.errors.any?
                        render json: @accepted_offer.x , status: 400 
                    else
                        render json: 'Bad request', status: 404 
                    end
                end
            end

            def calendar
                if current_user.role=='company'
                    private ch1=0,ch2=0
                    @jobs=Job.where(company_id: params[:company_id])
                    @individual_applications=IndividualApplication.where(job_id: @jobs)
                    sql1='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE companies.id='+current_user.company.id.to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                    if @accepted_individuals
                        ch1=1
                        render json: @accepted_individuals, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                    sql2='select colleges.name as College, companies.name as Company, accepted_offers.schedule FROM accepted_offers INNER JOIN college_applications ON college_applications.id=accepted_offers.approval_id INNER JOIN colleges ON colleges.id=college_applications.id INNER JOIN companies ON college_applications.company_id=companies.id WHERE companies.id='+current_user.company.id.to_s
                    @accepted_colleges=AcceptedOffer.connection.select_all(sql2)
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
                    sql='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE individuals.id='+current_user.individual.id.to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                    if @accepted_individuals
                        render json: @accepted_individuals, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                elsif current_user.role=='college'
                    sql='select colleges.name as College, companies.name as Company, accepted_offers.schedule FROM accepted_offers INNER JOIN college_applications ON college_applications.id=accepted_offers.approval_id INNER JOIN colleges ON colleges.id=college_applications.id INNER JOIN companies ON college_applications.company_id=companies.id WHERE college.id='+current_user.college.id.to_s
                    @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                    if @accepted_colleges
                        render json: @accepted_colleges, status: 200
                    else
                        render json: 'No Individual Applications found', status: 404
                    end
                end
            end

            private def accepted_params
                params.require(:accepted_offer).permit(:schedule)
            end
        end
    end
end

