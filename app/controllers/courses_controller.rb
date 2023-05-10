class CoursesController < ApplicationController

    before_action :authenticate_user!
    before_action :check_user
    
    def check_user
        if current_user.present? && current_user.role!='college'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end 

    def index
        @courses=Course.where(college_id: current_user.college.id)
    end
    
    def new
        @course=Course.new
        @college = College.find(params[:college_id])
    end
    def create
        @course=Course.new(course_params)
        @course.college_id=current_user.college.id
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
        @course=Course.find(params[:id])
        if @course
            if @course.college_id==current_user.college.id
                @college = College.find(params[:college_id])
                render :edit
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            flash[:notice]='Course not found'
        end
    end
    def update
        @course=Course.find(params[:id])
        if @course
            if @course.college.id==current_user.college.id
                
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
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            flash[:notice]='Not found'
        end
    end

    def destroy
        @course=Course.find(params[:id])
        if @course
            if @course.college.id==current_user.college.id
                if @course.destroy
                    flash[:notice]='Deleted Successfully'
                    redirect_to root_path
                else
                    flash[:notice]='Please try again'
                    redirect_to root_path
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            flash[:notice]='Course not found'
        end

    end

    private def course_params
        params.require(:course).permit(:name)
    end

end
