class CollegeApplicationsController < ApplicationController
    
    before_action :authenticate_user!
    
    before_action :check_user , only: [:new, :create]

    before_action :check_permission

    def check_permission
        if current_user.role!='individual' && current_user.permission.status!='Permitted' 
            flash[:notice]='You need admins permssion to access'
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
        if current_user.present? 
            if current_user.role=='college' && current_user.college.id==params[:college_id].to_i
                @college_applications=CollegeApplication.where(college_id: current_user.college.id).and(CollegeApplication.where(status: 'Under progress').or(CollegeApplication.where(status: 'Rejected')) )
            elsif current_user.role=='company' && current_user.company.id==params[:company_id].to_i
                @college_applications=CollegeApplication.where(company_id: current_user.company.id).and(CollegeApplication.where(status: 'Under progress') )
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end
 
    def create
        if current_user.present? && current_user.role='college'
            @students=Student.where(course_id: College.find(current_user.college.id).courses)
            if !@students.empty?
                @college_application=CollegeApplication.new
                @college_application.college_id=current_user.college.id
                @college_application.company_id=params[:company_id].to_i
                if @college_application.save
                    flash[:notice]="Applied Successfully !"
                    redirect_to '/college_applications/'+@college_application.id.to_s+'/students'
                else
                    flash[:notice]="Sorry! Retry Again !"
                    redirect_to root_path
                end
            else
                flash[:notice]='Kindly include your students details in courses before you apply'
                redirect_to root_path
            end
        else
            redirect_to root-path
        end
    end

    def update
        if current_user.role=='company'
            @ca=CollegeApplication.find_by(id: params[:id])
            if current_user.company.id==@ca.company.id
                @ca.update(status: 'Rejected')
                flash[:notice]='Rejected Successfully'
                redirect_to root_path
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def destroy
        if current_user.role=='college'
            @ca=CollegeApplication.find_by(id: params[:id])
            if @ca && @ca.college.id==current_user.college.id
                if @ca.status=='Rejected'
                    @ca.destroy
                    flash[:notice]='Deleted Application'
                    redirect_to '/colleges/'+current_user.college.id.to_s+'/college_applications'
                else
                    flash[:notice]='Cannot be Deleted'
                    redirect_to '/colleges/'+current_user.college.id.to_s+'/college_applications'
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to '/colleges/'+current_user.college.id.to_s+'/college_applications'
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end
end
