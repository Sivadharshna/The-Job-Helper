module Api
    module V1
        class StudentsController < Api::ApplicationController
            before_action :doorkeeper_authorize!
    
            
            before_action :check_user , only: [:new, :create, :edit, :update]

            before_action :check_user_index, only: [:index]

            def check_user_index
                if current_user.present? && current_user.role=='individual'
                    render json: 'Restricted Access', status: 403
                end
            end
            
            def check_user
                if current_user.present? && current_user.role!='college'
                    render json: 'Restricted Access', status: 403
                end
            end
            
            
            def index
                if current_user.role=='college' && current_user.college.id==params[:college_id].to_i
                    @students=Student.where(course_id: College.find(params[:college_id]).courses)
                    if @students
                        render json: @student, status: 200
                    else
                        render json: 'Not found', status: 404
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end

            def select
                if current_user.role=='college' && current_user.college.id==params[:college_id].to_i
                    @students=Student.where(course_id: College.find(params[:college_id]).courses)
                    render json: @students, status: 200
                else
                    render json: 'Restricted Access', status: 403
                end
            end

            def appoint
                    if current_user.role=='company'
                        @college_application=CollegeApplication.find(params[:college_application_id])
                        if @college_application
                            @student=Student.find(params[:student_id])
                            exist=@student.course.college.college_applications.where(company_id: current_user.company.id)
                            if exist
                                if check_student_not_selected(@college_application , @student)==true
                                    if @college_application.students << @student
                                        render json: 'Selected Successfully', status: 200
                                    else
                                        render json: 'Please retry again', status: 422                                    end
                                else
                                    render json: 'Already selected', status: 422
                                end
                            else
                                render json: 'Restricted Access', status: 403
                            end
                        else
                            render json: 'Not found', status: 404
                        end
                    else
                        render json: 'Restricted Access', status: 403
                    end
                
            end
        
            private def check_student_not_selected(college_application, student)
                if college_application.students.exists?(student.id)==true
                    return false
                else
                    return true
                end
            end
            

            def update

                @course=Course.find(params[:course_id])
                if current_user.role=='college' && current_user.college.id=@course.college.id
                    @student=Student.find(params[:id])
                    if @student
                        if @student.course.college.id==current_user.college.id
                            if @student.update(student_params)
                                render json: 'Updated Successfully', status: 200
                            else
                                render json:  @student.errors , status: 422
                            end
                        else
                            render json: 'Restricted Access', status: 403
                        end
                    else
                        render json: 'Not found', status: 404
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end

            def create
                @course=Course.find(params[:course_id])
                if @course
                    if current_user.role=='college' && current_user.college.id=@course.college.id
                        @student=Student.new(student_params)
                        @student.course_id=params[:course_id]
                        if @student.save
                            render json: @student, status: 200
                        else
                            render json: @student.errors, status: 422
                        end  
                    else
                        render json: 'Restricted Access', status: 403
                    end 
                else
                    render json: 'Not found', status: 404
                end  
            end

            def destroy

                @course=Course.find(params[:course_id])
                if current_user.role=='college' && current_user.college.id=@course.college.id
                    @student=Student.find(params[:id])
                    if @student
                        if @student.course.college.id==current_user.college.id
                            if @student.destroy
                                render json: 'Deleted Successfully'
                            else
                                render json: 'Some error occurred', status: 500
                            end
                        else
                            render json: 'Restricted Access', status: 403
                        end
                    else
                        render json: 'Not found', status: 404
                    end
                else
                    render json: 'Restricted Access', status: 403
                end

            end

            def appointed
                if current_user.role=='college' 
                    @college_application=CollegeApplication.find(params[:college_application_id])
                    if @college_application && @college_application.college.id==current_user.college.id
                        @students=@college_application.students
                        render json: @students, status: 200
                    else
                        render json: 'Restricted Access', status: 403
                    end
                elsif current_user.role=='company'
                    @college_application=CollegeApplication.find(params[:college_application_id])
                    if @college_application && @college_application.company.id==current_user.company.id
                        @students=@college_application.students
                        render json: @students, status: 200
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end


            private def student_params
                params.require(:student).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :cgpa, :graduation_year, :placement_status)
            end
        end
    end
end
