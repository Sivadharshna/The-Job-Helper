class CollegeApplicationsController < ApplicationController
    
    before_action :authenticate_user!
    
    before_action :check_user , only: [:new, :create, :edit, :update]

    #callback methods
    def check_user
        if current_user.present? && current_user.role!='college'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    def index 
        if current_user.present? 
            if current_user.role=='college' && current_user.college.id==params[:college_id].to_i
                @college_applications=CollegeApplication.where(college_id: current_user.college.id).and(CollegeApplication.where(status: 'Under progress') )
            elsif current_user.role=='company' && current_user.company.id==params[:company_id].to_i
                @college_applications=CollegeApplication.where(company_id: current_user.company.id).and(CollegeApplication.where(status: 'Under progress') )
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end

    def create
        if current_user.present? && current_user.role='college'
            @college_application=CollegeApplication.new
            @college_application.college_id=current_user.college.id
            @college_application.company_id=params[:company_id].to_i
            if @college_application.save
                flash[:notice]="Applied Successfully !"
                redirect_to '/companies/'+params[:company_id]+'/students'
            else
                flash[:notice]="Sorry! Retry Again !"
                redirect_to root_path
            end
        else
            redirect_to root-path
        end
    end
end
