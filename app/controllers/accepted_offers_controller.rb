class AcceptedOffersController < ApplicationController
    
    ###
    #callbacks
    before_action :check_user, only: [:new]
    

    #callback methods
    def check_user
        if current_user.present? && current_user.role!='company'
        flash[:notice]='Restricted Access'
        redirect_to root_path
        end
    end


    ###
=begin
    
        
            if current_user.role=='individual'
                @accepted_offer=IndividualApplication.joins(:accepted_offer).where(individual_id: params[:individual_id])
                #@individual_applications=IndividualApplication  .where(individual_id: current_user.individual.id)
                #@accepted_offers=AcceptedOffer.all.where(approval_type: 'IndividualApplication')   
            elsif current_user.role=='company'
                #@accepted_individuals=Job.joins(individual_applications: :accepted_offer).where(company_id: params[:company_id])
                @jobs=Job.where(company_id: params[:company_id])
                @accepted_individuals=IndividualApplication.joins(:accepted_offer).where(job_id: @jobs)
                @accepted_colleges=CollegeApplication.joins(:accepted_offer).where(company_id:params[:company_id])
            elsif current_user.role=='college'
                @accepted_offer=CollegeApplication.joins(:accepted_offer).where(college_id: params[:college_id])

            end
=end
    def index
        if current_user.present?
            if current_user.role=='company'
                @jobs=Job.where(company_id: params[:company_id])
                @individual_applications=IndividualApplication.where(job_id: @jobs)
                sql1='select accepted_offers.id as Id, individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE companies.id='+params[:company_id].to_s
                @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
                sql2='select colleges.id as Id, colleges.name as College, companies.name as Company, accepted_offers.schedule FROM accepted_offers INNER JOIN college_applications ON college_applications.id=accepted_offers.approval_id INNER JOIN colleges ON colleges.id=college_applications.college_id INNER JOIN companies ON college_applications.company_id=companies.id WHERE companies.id='+params[:company_id].to_s
                @accepted_colleges=AcceptedOffer.connection.select_all(sql2)
            elsif current_user.role=='individual'
                sql='select individuals.name as Individual , jobs.name as Job, companies.name as Company, jobs.salary, accepted_offers.schedule FROM accepted_offers INNER JOIN individual_applications ON individual_applications.id=accepted_offers.approval_id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN companies ON jobs.company_id=companies.id WHERE individuals.id='+params[:individual_id].to_s
                @accepted_individuals=AcceptedOffer.connection.select_all(sql1)
            end
        end  
    end

    def new
        @accepted_offer=AcceptedOffer.new
        #if current_user.present? && current_user.role=='company'
        #else
        #    redirect_to root_path
        #end
    end
    def create
        @accepted_offer=AcceptedOffer.new(accepted_params)
        if params[:application_type] == 'individual_applications'
            @accepted_offer.approval_id=params[:application_id]
            @accepted_offer.approval_type='IndividualApplication'
        elsif params[:application_type] == 'college_applications'
            @accepted_offer.approval_id=params[:application_id]
            @accepted_offer.approval_type='CollegeApplication' 
        end
        if @accepted_offer.save
            if params[:application_type] == 'individual_applications'
                @individual_application=IndividualApplication.find(params[:application_id])
                @individual_application.update(status: 'Approved')
            elsif params[:application_type] == 'college_applications'
                @college_application=CollegeApplication.find(params[:application_id])
                @college_application.update(status: 'Approved')
            end
            flash[:notice]="Application Approved!"
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end

    private def accepted_params
        params.permit(:schedule)
    end
end
