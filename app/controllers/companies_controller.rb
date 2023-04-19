class CompaniesController < ApplicationController


    ####
    #callbacks
    before_action :check_user , only: [:new, :create, :edit, :update, :select_students]
    before_action :check_user_index, only: [:index]

    private def check_user_index
        if current_user.present? && current_user.role!='college'
            redirect_to root_path
        end
    end

    #callback methods
    private def check_user
        if current_user.present? && current_user.role!='company'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    ####
    def index
        @companies=Company.all
    end
    
    def show
        if current_user.present?
            @company=Company.find(params[:id])
        else
            redirect_to root_path
        end
    end

    def edit
        if current_user.present?
            @company=Company.find(params[:id])
        else
            redirect_to root_path
        end
    end
    def update
        if current_user.present?
            @company=Company.find(params[:id])
            if @company.update(company_params)    
                flash[:notice]='Updated Sucessfully!'
                redirect_to '/companies/'+@company.id.to_s
            else
                if @company.errors.any? 
                    @company.errors.full_messages.each do |message|
                        flash[:notice]=message
                    end
                end
                render :edit, status: :unprocessable_entity
            end
        else
            redirect_to root_path
        end
    end

    def new
        if current_user.present?
            @company=Company.new
        else
            redirect_to root_path
        end
    end
    def create
        if current_user.present?
            @company=Company.new(company_params)
            @company.user_id=current_user.id
            if @company.save
                @permission=Permission.new
                @permission.user_id=current_user.id
                @permission.save
                flash[:notice]='Saved Sucessfully!'
                redirect_to '/companies/'+@company.id.to_s
            else
                if @company.errors.any? 
                    @company.errors.full_messages.each do |message|
                        flash[:notice]=message
                    end
                end
                render :new , status: :unprocessable_entity
            end
        else
            redirect_to root_path
        end
    end

    private def company_params
        params.require(:company).permit(:name, :description, :address, :website_link, :contact_no, :email_id)
    end

    def select_students
        @company=Company.find(current_user.company.id)
        if @company
            @student=Student.find(params[:student_id])
            
            if check_student_not_selected(@company , @student)==true
                if @company.students << @student
                    flash[:notice] ='Selected Successfully'
                else
                    flash[:notice] ='Please try Again'
                end
            else
                flash[:notice] = 'Already selected'
            end
        else

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
