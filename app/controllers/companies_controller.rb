class CompaniesController < ApplicationController


    before_action :authenticate_user!
    before_action :check_user , only: [:new, :create, :edit, :update]
    before_action :check_user_index, only: [:index]

    before_action :check_permission

    def check_permission
        if current_user.role!='individual' && current_user.role!='company' && current_user.permission.status!='Permitted' 
            flash[:notice]='You need admins permssion to access'
            redirect_to root_path
        end
    end

    private def check_user_index
        if current_user.present? && current_user.role!='college'
            redirect_to root_path
        end
    end 

    
    private def check_user
        if current_user.present? && current_user.role!='company'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    def index
        @companies=Company.all
    end
    
    def show
        if current_user.present?
            if current_user.role=='company'
                if current_user.company.id==params[:id].to_i
                    @company=Company.find(params[:id])
                    if @company
                        render :show
                    else
                        flash[:notice]='Not found'
                    end
                else
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            else
                @company=Company.find(params[:id])
                if @company
                    render :show
                else
                    flash[:notice]='Not found'
                end
            end
        else
            redirect_to root_path
        end
    end

    def edit
        if current_user.present?
            if current_user.role=='company' && current_user.company.id==params[:id].to_i
                @company=Company.find(params[:id])
                if @company
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
            if current_user.role=='company' && current_user.company.id==params[:id].to_i
                @company=Company.find(params[:id])
                if @company
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
        params.require(:company).permit(:name, :photo, :description, :address, :website_link, :contact_no, :email_id)
    end

end
