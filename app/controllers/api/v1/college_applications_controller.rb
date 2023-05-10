module Api
    module V1
        class CollegeApplicationsController < Api::ApplicationController

            before_action :doorkeeper_authorize!

            before_action :check_user , only: [:new, :create, :edit, :update]

            def check_user
                if current_user.present? && current_user.role!='college'
                    render json: 'Restricted Access', status: 403
                end
            end

            def index
                        if current_user.role=='company' 
                            @college_applications=CollegeApplication.where(company_id: current_user.company.id).and(CollegeApplication.where(status: 'Under progress') )
                            if @college_applications
                                render json: @college_applications, status: 200
                            else
                                render json: 'No applications found' ,status: 404
                            end
                        elsif current_user.role=='college'
                            @college_applications=CollegeApplication.where(college_id: current_user.college.id).and(CollegeApplication.where(status: 'Under progress') )
                            if @college_applications
                                render json: @college_applications, status: 200
                            else
                                render json: 'No applications found', status: 404
                            end
                        else
                            render json: 'Restricted Access' ,status: 403
                        end
            end
            
            def create
                @college_application=CollegeApplication.new
                @college_application.college_id=current_user.college.id
                @college_application.company_id=params[:company_id]
                if @college_application.save
                    render json: 'Applied Successfully', status: 200
                else
                    render json: @college_application.errors , status: 422
                end   
            end    

        end
    end
end

