class AcceptedOffersController < ApplicationController
    before_action :authenticate_user!

    before_action :check_user, only: [:new, :create]
    
    def check_user
        if current_user.present? && current_user.role!='company'
        flash[:notice]='Restricted Access'
        redirect_to root_path
        end
    end

    def index
        if current_user.present?
            if current_user.role=='company'
                @individual_applications=IndividualApplication.joins(:job).where(job: {company_id: current_user.company.id} )
                @accepted_individuals=AcceptedOffer.where(approval_type: 'IndividualApplication').and(AcceptedOffer.where(approval_id: @individual_applications))

                @college_applications=CollegeApplication.where(company_id: current_user.company.id)
                @accepted_colleges=AcceptedOffer.where(approval_type: 'CollegeApplication').and(AcceptedOffer.where(approval_id: @college_applications))
                flash[:notice]='The schedules will disappear after 10 days from  their scheduled date'
            elsif current_user.role=='individual'
                @individual_applications=IndividualApplication.where(individual_id: current_user.individual.id )
                @accepted_individuals=AcceptedOffer.where(approval_type: 'IndividualApplication').and(AcceptedOffer.where(approval_id: @individual_applications))
                flash[:notice]='The schedules will disappear after 10 days from  their scheduled date'
            elsif current_user.role=='college'
                @college_applications=CollegeApplication.where(college_id: current_user.college.id)
                @accepted_colleges=AcceptedOffer.where(approval_type: 'CollegeApplication').and(AcceptedOffer.where(approval_id: @college_applications))
                flash[:notice]='The schedules will disappear after 10 days from  their scheduled date'
            end
        end  
    end

    def new
        @accepted_offer=AcceptedOffer.new
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
            flash[:notice]='Saved Successfully'
            redirect_to root_path
        else
            if @accepted_offer.errors.any?
                @accepted_offer.errors.full_messages.each do |message|
                    flash[:notice]=message
                end
            end
            render :new, status: :unprocessable_entity
        end
    end

    def calendar
        if current_user.present?
            if current_user.role=='company'
                @individual_applications=IndividualApplication.joins(:job).where(job: {company_id: current_user.company.id} )
                @accepted_individuals=AcceptedOffer.where(approval_type: 'IndividualApplication').and(AcceptedOffer.where(approval_id: @individual_applications))

                @college_applications=CollegeApplication.where(company_id: current_user.company.id)
                @accepted_colleges=AcceptedOffer.where(approval_type: 'CollegeApplication').and(AcceptedOffer.where(approval_id: @college_applications))
                
            elsif current_user.role=='individual'
                @individual_applications=IndividualApplication.where(individual_id: current_user.individual.id )
                @accepted_individuals=AcceptedOffer.where(approval_type: 'IndividualApplication').and(AcceptedOffer.where(approval_id: @individual_applications))

            elsif current_user.role=='college'
                @college_applications=CollegeApplication.where(college_id: current_user.college.id)
                @accepted_colleges=AcceptedOffer.where(approval_type: 'CollegeApplication').and(AcceptedOffer.where(approval_id: @college_applications))
            end
        end   
    end

    private def accepted_params
        params.permit(:schedule)
    end
end
