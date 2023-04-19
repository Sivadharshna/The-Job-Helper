module Api
    module V1
        class StudentsController < Api::ApplicationController
            before_action :doorkeeper_authorize!
    
            ####
            #callbacks
            before_action :check_user , only: [:new, :create, :edit, :update]

            #callback methods
            def check_user
                if current_user.present? && current_user.role!='college'
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            end
            
            ##########################################
            def index
                @student=Student.where(course_id: params[:course_id])
                render json: @student, status: 200
            end
            
            def show
                @student=Student.find_by(id: params[:id])
                if @student
                    render json: @student, status: 200
                else
                    render json:{ error: 'Not found' }
                end
            end

            def update
                @student=Student.find_by(id: params[:id])
                if @student
                    if @student.update(student_params)
                        render json: 'Updated Successfully'
                    else
                        render json: @student.errors
                    end
                else
                    render json: { error: 'Not found' }
                end
            end

            def create
                @student=Student.new(student_params)
                @student.course_id=params[:course_id]
                if @student.save
                    render json: @student, status: 200
                else
                    render json: @student.errors
                end   
            end

            def destroy
                @student=Student.find_by(id: params[:id])
                if @student
                    if @student.destroy
                        render json: 'Deleted Successfully'
                    else
                        render json: @student.errors
                    end
                else
                    render json: 'Not found'
                end
            end


            private def student_params
                params.require(:student).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :cgpa, :graduation_year, :placement_status)
            end
        end
    end
end
