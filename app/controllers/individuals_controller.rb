    class IndividualsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_user , only: [:new, :create, :edit, :update]
    
    before_action :check_user_show, only: [:show]

    before_action :check_permission

    def check_permission
        if current_user.role!='individual' && current_user.permission.status!='Permitted' 
            flash[:notice]='You need admins permssion to access'
            redirect_to root_path
        end
    end

    def check_user
        if current_user.present? && current_user.role!='individual'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def check_user_show
        if current_user.present? && current_user.role=='college'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def show
        if current_user.role=='individual' && current_user.individual.id==params[:id].to_i
            @individual=Individual.find_by(id: params[:id])
            if @individual
                render :show, status: :ok
            else
                flash[:notice]='Profile not found'
                redirect_to root_path
            end 
        elsif current_user.role=='company'  
            @company=Company.find(current_user.company.id)
            @individual=Individual.find_by(id: params[:id])
            if @individual
                if !@individual.individual_applications.where(jobs: @company.jobs).empty?
                    render :show, status: :ok
                else
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            else
                flash[:notice]='Not found'
                redirect_to root_path
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end
 
    def new
        if current_user.present?
            @individual=Individual.new
        else
            redirect_to root_path
        end
    end
    def create
        if current_user.present?
            @individual=Individual.new(individual_params)
            @individual.user_id=current_user.id
            if @individual.save
                flash[:notice]="Profile created successfully !"
                redirect_to '/individuals/'+@individual.id.to_s
            else
                if @individual.errors.any?
                    @individual.errors.full_messages.each do |e|
                        flash[:notice]=e
                    end
                end
                render :new, status: :unprocessable_entity
            end
        else
            redirect_to root_path
        end
    end

    def edit
        if current_user.role=='individual' && current_user.individual.id==params[:id].to_i
            @individual=Individual.find(params[:id])
            if @individual
                render :edit
            else
                flash[:notice]='Profile not found'
                redirect_to root_path
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end
    def update
        if current_user.role=='individual' && current_user.individual.id==params[:id].to_i
            @individual=Individual.find(params[:id])
            if @individual
                if @individual.update(individual_params)
                    flash[:notice]="Profile Updated successfully !"
                    redirect_to '/individuals/'+@individual.id.to_s
                else
                    render :edit,  status: :unprocessable_entity
                end
            else
                flash[:notice]='Profile not found'
                redirect_to root_path
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    private def individual_params
        params.require(:individual).permit(:name, :resume, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :experiece, :address, :age,  :bachelors_degree, :masters_degree, :contact_no, :email_id)
    end
end
