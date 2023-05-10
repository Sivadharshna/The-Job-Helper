module Api
    module V1
        class CollegesController < Api::ApplicationController
            before_action :doorkeeper_authorize!
                
            before_action :check_user , only: [:new, :create, :edit, :update]
            before_action :check_user_show, only: [:show]

            def check_user_show
                if current_user.present? && current_user.role=='individual'
                    render json: 'Restricted Access' , status: 403
                end
            end
            
            def check_user
                if current_user.present? && current_user.role!='college'
                    render json: 'Restricted Access' , status: 403
                end
            end

            
            def show
                if current_user.present?
                    if current_user.role=='college'
                        if current_user.college.id==params[:id].to_i
                            @college=College.find_by(id: params[:id])
                            if @college
                                render json: @college, status: 200
                            else
                                render json:{ error: 'Not found' }
                            end
                        else
                            render json: 'Restricted Access', status: 403
                        end
                    elsif current_user.role=='company'
                        @college=College.find_by(id: params[:id])
                        if @college
                            exist=@college.college_applications.where(company_id: current_user.company.id)
                            if exist
                                render json: @college, status: 200
                            else
                                render json: 'Restricted Access', status: 403
                            end
                        else
                            render json:{ error: 'Not found' }, status: 404
                        end
                    else
                        render json: 'Restricred Access', status: 403
                    end
                else
                    render json: 'No user', status: 302
                end
            end

            def update
                if current_user.present?
                    if current_user.role=='college' && current_user.college.id==params[:id].to_i
                        @college=College.find_by(id: params[:id])
                        if @college
                            if @college.update(college_params)
                                render json: 'Updated Successfully', status: 200
                            else
                                render json: {error: @college.errors }, status: 422
                            end
                        else
                            render json: 'Not found' ,status: 404
                        end
                    else
                        render json: 'Restrictes Access', status: 403
                    end
                else
                    render json: 'No user', status: 302
                end
            end

            def create
                if current_user.present?
                    @college=College.new(college_params)
                    @college.user_id=current_user.id
                    if @college.save
                        @permission=Permission.new
                        @permission.user_id=current_user.id
                        @permission.save
                        render json: @college, status: 200
                    else
                        render json: @college.errors
                    end   
                else
                    render json: 'No user', status: 302
                end
            end

            private def college_params
                params.require(:college).permit(:name, :address, :contact_no, :email_id, :website_link) 
            end

            def select_students
                if current_user.present?
                    if current_user.role=='college' 
                        @company=Company.find(params[:company_id])
                        if @company
                            @student=Student.find(params[:student_id])
                            exist=@student.course.college.college_applications.where(company_id: params[:company_id])
                            if exist
                                if check_student_not_selected(@company , @student)==true
                                    if @company.students << @student
                                        render json: 'Selected Successfully', status: 200
                                    else
                                        render json: 'Please try Again' , status: 500 #Internal server error
                                    end
                                else
                                    render json: 'Already selected', status: 409 #conflict 
                                end
                            else
                                render json: 'Restricted Access', status: 403
                            end
                        else
                            render json: 'Not found' , status: 404
                        end
                    else
                        render json: 'Restricted Access' , status: 403
                    end
                else
                    render json: 'No user', status: 302
                end
            end

            private def check_student_not_selected(company, student)
                if company.students.exists?(student.id)==true
                    return false
                else
                    return true
                end
            end
            
        end
    end
end
