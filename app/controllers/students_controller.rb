class StudentsController < ApplicationController

    before_action :authenticate_user!
    
    before_action :check_user , only: [:new, :create, :edit, :update, :destroy, :select]

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
        if current_user.role=='college' && current_user.college.id==params[:college_id].to_i
            @students=Student.where(course_id: College.find(params[:college_id]).courses)
        elsif current_user.role=='company'
            @company=Company.find(current_user.company.id)
            @students=@company.students
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def select
        if current_user.role=='college' 
            @students=Student.where(course_id: College.find(current_user.college.id).courses)
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def appointed
        if current_user.role=='college' 
            @college_application=CollegeApplication.find(params[:college_application_id])
            if @college_application && @college_application.college.id==current_user.college.id
                @students=@college_application.students
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        elsif current_user.role=='company'
            @college_application=CollegeApplication.find(params[:college_application_id])
            if @college_application && @college_application.company.id==current_user.company.id
                @students=@college_application.students
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def appoint
        if current_user.present?
            if current_user.role=='company'
                @college_application=CollegeApplication.find(params[:college_application_id])
                if @college_application
                    @student=Student.find(params[:student_id])
                    exist=@student.course.college.college_applications.where(company_id: current_user.company.id)
                    if exist
                        if check_student_not_selected(@college_application , @student)==true
                            if @college_application.students << @student
                                flash[:notice] ='Selected Successfully'
                                redirect_to '/college_applications/'+@college_application.id.to_s+'/companies/'+current_user.company.id.to_s+'/students/view'
                            else
                                flash[:notice] ='Please try Again'
                            end
                        else
                            flash[:notice] = 'Already selected'
                        end
                    else
                        flash[:notice]='Restricted Access'
                    end
                else
                    flash[:notice]='Not found'
                end
            else
                flash[:notice]='Restricted Access'
            end
        else
            redirect_to root_path
        end
    end

    private def check_student_not_selected(college_application, student)
        if college_application.students.exists?(student.id)==true
            return false
        else
            return true
        end
    end

    def new
        @student=Student.new
        @course=Course.find(params[:course_id])
    end
    def create
        @course=Course.find(params[:course_id])
        if current_user.role=='college' && current_user.college.id=@course.college.id
            @student=Student.new(student_params)
            @student.course_id=params[:course_id]
            if @student.save
                flash[:notice]='Created Successfully'
                redirect_to root_path
            else
                render :new, status: :unprocessable_entity
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    def edit
        @course=Course.find(params[:course_id])
        if current_user.role=='college' && current_user.college.id=@course.college.id
            @student=Student.find(params[:id])
            if @student
                if @student.course.college.id==current_user.college.id
                    render :edit
                else
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            else
                flash[:notice]='Not found'
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end

    end
    def update
        @course=Course.find(params[:course_id])
        if current_user.role=='college' && current_user.college.id=@course.college.id
            @student=Student.find(params[:id])
            if @student
                if @student.course.college.id==current_user.college.id
                    if @student.update(student_params)
                        flash[:notice]='Updated Successfully!'
                        redirect_to root_path
                    else
                        render :edit, status: :unprocessable_entity
                    end
                else
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            else
                flash[:notice]='Not found'
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end

    end


    def destroy
        
        @course=Course.find(params[:course_id])
        if current_user.role=='college' && current_user.college.id=@course.college.id
            @student=Student.find(params[:id])
            if @student
                if @student.course.college.id==current_user.college.id
                    if @student.destroy
                        flash[:notice]='Deleted Successfully'
                    else
                        flash[:notice]='Some error occurred'
                        redirect_to root_path
                    end
                else
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            else
                flash[:notice]='Not found'
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    private def student_params
        params.require(:student).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :cgpa, :graduation_year, :placement_status)
    end
end
