module Api
    module V1
        class CoursesController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            
            
            before_action :check_user

            before_action :check_permission

            def check_permission
                if current_user.role!='individual' && current_user.role!='college' && current_user.permission.status!='Permitted' 
                    render json: 'You need admins permssion to access', status: 403
                end
            end
            
            def check_user
                if current_user.present? && current_user.role!='college'
                    render json:'Restricted Access', status: 403
                end
            end

            def index
                @course=Course.where(college_id: current_user.college.id)
                if @courses
                    render json: @course, status: 200
                else
                    render json: 'Not found', status: 404
                end
            end
            
            def update
                @course=Course.find_by(id: params[:id])
                if @course
                    if @course.college.id==current_user.college.id
                        if @course.update(course_params)
                            render json: 'Updated Successfully'
                        else
                            render json: @course.errors
                        end
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    render json:   'Not found' , status: 404
                end
            end

            def create
                @course=Course.new(course_params)
                @course.college_id=current_user.college.id
                if @course.save
                    render json: @course, status: 200
                else
                    render json: { error: @course.errors}, status: 422
                end   
            end

            def destroy
                @course=Course.find_by(id: params[:id])
                if @course
                    if @course.college_id=current_user.college.id
                        if @course.destroy
                            render json: 'Deleted Successfully'
                        else
                            render json: @course.errors
                        end
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    render json: 'Not found'
                end
            end


            private def course_params
                params.require(:course).permit(:name)
            end

        end
    end
end