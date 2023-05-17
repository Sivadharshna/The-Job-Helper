module Api
    module V1
        class CollegeApplicationsController < Api::ApplicationController

            before_action :doorkeeper_authorize!

            before_action :check_user , only: [:new, :create]

            before_action :check_permission

            def check_permission
                if current_user.role!='individual' && current_user.permission.status!='Permitted' 
                    render json: 'You need admins permssion to access', status: 403
                end
            end

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
                @students=Student.where(course_id: College.find(current_user.college.id).courses)
                if !@students.empty?
                    if @college_application.save
                        render json: 'Applied Successfully', status: 200
                    else
                        render json: @college_application.errors , status: 422
                    end   
                else
                    render json: 'Include your students details before applying', status: 422
                end
            end   
            
            def update
                if current_user.role=='company'
                    @ca=CollegeApplication.find_by(id: params[:id])
                    if current_user.company.id==@ca.company.id
                        @ca.update(status: 'Rejected')
                        render json: @ca, status: 200
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    render json: 'Restricted Access' , status: 403
                end
            end
        
            def destroy
                if current_user.role=='college'
                    @ca=CollegeApplication.find_by(id: params[:id])
                    if @ca && @ca.college.id==current_user.college.id
                        if @ca.status=='Rejected'
                            @ca.destroy
                            render json: 'Deleted Application', status: 200
                        else
                            render json: 'Cannot be deleted', status: 403
                        end
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end

        end
    end
end

