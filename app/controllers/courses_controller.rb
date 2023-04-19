class CoursesController < ApplicationController

    
    before_action :check_user
    
    def check_user
        if current_user.present? && current_user.role!='college'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def index
        @course=Course.where(college_id: params[:college_id])
    end
    
    def new
        @course=Course.new
        @college = College.find(params[:college_id])
    end
    def create
        @course=Course.new(course_params)
        @course.college_id=params[:college_id]
        if @course.save
            flash[:notice]='Saved Successfully!'
            redirect_to root_path
        else
            if @course.errors.any? 
                @course.errors.full_messages.each do |message|
                    flash[:notice]=message
                end
            end
            render :new, status: :unprocessable_entity
        end
    end

    def edit
        @course=Course.where(params[:id])
        @college = College.find(params[:college_id])
    end
    def update
        @course=Course.find(params[:id])
        @course.college_id=params[:college_id]
        if @course.update(course_params)
            flash[:notice]='Updated Successfully!'
            redirect_to root_path
        else
            if @course.errors.any? 
                @course.errors.full_messages.each do |message|
                    flash[:notice]=message
                end
            end
            render :new, status: :unprocessable_entity
        end
    end

    def destroy
        @course=Course.find(params[:id])
        if @course.destroy
            flash[:notice]='Deleted Successfully'
        else
            flash[:notice]='Please try again'
        end

    end

    private def course_params
        params.require(:course).permit(:name)
    end

end
