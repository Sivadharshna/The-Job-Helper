class StudentsController < ApplicationController

    
    before_action :check_user , only: [:new, :create, :edit, :update, :destroy]

    before_action :check_user_index, only: [:index]

    def check_user_index
        if current_user.present? && current_user.role=='individual'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    
    def check_user
        if current_user.present? && current_user.role!='college'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    
    def index
        if current_user.role=='company'
            @students=Student.where(course_id: College.find(params[:college_id]).courses)
        end
    end


    def new
        @student=Student.new
        @course=Course.find(params[:course_id])
    end
    def create
        @student=Student.new(student_params)
        @student.course_id=params[:course_id]
        if @student.save
            flash[:notice]='Created Successfully'
            redirect_to root_path
        else
            render :new, status: :unprocessable_entity
        end
    end


    def edit
        @student=Student.find(params[:id])
    end
    def update
        @student=Student.find(params[:id])
        if @student.update(student_params)
            flash[:notice]='Updated Successfully!'
            redirect_to root_path
        else
            render :edit, status: :unprocessable_entity
        end
    end


    def destroy
        @student=Student.find(params[:id])
        @student.destroy
        flash[:notice]='Deleted Successfully'
    end

    private def student_params
        params.require(:student).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :cgpa, :graduation_year, :placement_status)
    end
end
