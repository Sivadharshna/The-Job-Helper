class CollegesController < ApplicationController

    before_action :authenticate_user!
    before_action :check_user , only: [:new, :create, :edit, :update]
    before_action :check_user_show, only: [:show]

    def check_user_show
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

    def show 
        if current_user.present?
            if current_user.role=='college'
                if current_user.college.id==params[:id].to_i
                    @college=College.find_by(id: params[:id])
                else
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            elsif current_user.role=='company'
                @college=College.find_by(id: params[:id])
                if @college
                    exist=@college.college_applications.where(company_id: current_user.company.id)
                    if exist
                        render :show
                    else
                        flash[:notice]='Restricted Access'
                        redirect_to root_path
                    end
                else
                    flash[:notice]='Profile not found'
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end       
    end

    def new
        if current_user.present?
            @college=College.new
        else
            redirect_to root_path
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
                flash[:notice]='Saved Sucessfully!'
                redirect_to root_path
            else
                if @college.errors.any?
                    @college.errors.full_messages.each do |message|
                        flash[:notice]=message
                    end
                end
                render :new, status: :unprocessable_entity
            end
        else  
            redirect_to root_path
        end
    end

    def edit
        if current_user.present?
            if current_user.role=='college' && current_user.college.id==params[:id].to_i
                @college=College.find(params[:id])
                if @college
                    render :edit
                else
                    flash[:notice]='No profile exists'
                    redirect_to root_path
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end
    def update
        if current_user.present?
            if current_user.role=='college' && current_user.college.id==params[:id].to_i
                @college=College.find(params[:id])
                if @college
                    if @college.update(college_params)
                        flash[:notice]='Updated Sucessfully'
                        redirect_to root_path
                    else
                        if @college.errors.any? 
                            @college.errors.full_messages.each do |message|
                                flash[:notice]=message
                            end
                        end
                        render :edit, status: :unprocessable_entity
                    end
                else
                    flash[:notice]='Not found'
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end

    def select_students 
        if current_user.present?
            if current_user.role=='college'
                @college=College.find(current_user.college.id)
                if @college
                    @student=Student.find(params[:student_id])
                    exist=@student.course.college.college_applications.where(company_id: params[:company_id])
                    if exist
                        @company=Company.find(params[:company_id])
                        if check_student_not_selected(@company , @student)==true
                            if @company.students << @student
                                flash[:notice] ='Selected Successfully'
                                redirect_to '/companies/'+@company.id.to_s+'/students'
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

    private def college_params
        params.require(:college).permit(:name, :photo, :address, :contact_no, :email_id, :website_link) 
    end

    private def check_student_not_selected(company, student)
        if company.students.exists?(student.id)==true
            return false
        else
            return true
        end
    end
      
end
