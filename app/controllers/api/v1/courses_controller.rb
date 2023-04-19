module Api
    module V1
        class CoursesController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            ### 
            #callbacks
            before_action :check_user
            #callback methods
            def check_user
                if current_user.present? && current_user.role!='college'
                    render json:'Unauthorised', status: 403
                end
            end

            ##########################################
            def index
                @course=Course.where(college_id: params[:college_id])
                render json: @course, status: 200
            end
            
            def show
                @course=Course.find_by(id: params[:id])
                if @course
                    render json: @course, status: 200
                else
                    render json:{ error: 'Not found' }
                end
            end

            def update
                @course=Course.find_by(id: params[:id])
                if @course
                    if @course.update(course_params)
                        render json: 'Updated Successfully'
                    else
                        render json: @course.errors
                    end
                else
                    render json: { error: 'Not found' }
                end
            end

            def create
                @course=Course.new(course_params)
                @course.college_id=params[:college_id]
                if @course.save
                    render json: @course, status: 200
                else
                    render json: @course.errors
                end   
            end

            def destroy
                @course=Course.find_by(id: params[:id])
                if @course
                    if @course.destroy
                        render json: 'Deleted Successfully'
                    else
                        render json: @course.errors
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