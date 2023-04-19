    class IndividualsController < ApplicationController

    ####
    #callbacks
    before_action :check_user , only: [:new, :create, :edit, :update]
    
    before_action :check_user_show, only: [:show]
    #callback methods
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
        if current_user.present?
            @individual=Individual.find(params[:id])
        else
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
                @permission=Permission.new
                @permission.user_id=current_user.id
                @permission.save
                flash[:notice]="Profile created successfully !"
                redirect_to '/individuals/show/'+@individual.id.to_s
            else
                render :new, status: :unprocessable_entitiy
            end
        else
            redirect_to root_path
        end
    end

    def edit
        @individual=Individual.find(params[:id])
    end
    def update
        @individual=Individual.find(params[:id])
        if @individual.update(individual_params)
            flash[:notice]="Profile Updated successfully !"
            redirect_to '/individuals/'+@individual.id.to_s
        else
            render :edit,  status: :unprocessable_entity
        end
    end


    private def individual_params
        params.require(:individual).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :experiece, :address, :age,  :bachelors_degree, :masters_degree, :contact_no, :email_id)
    end
end
