class CollegesController < ApplicationController

    
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
        @college=College.find(params[:id])
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
            @college=College.find(params[:id])
        else
            redirect_to root_path
        end
    end
    def update
        if current_user.present?
            @college=College.find(params[:id])
            if @college.update(college_params)
                flash[:notice]='Updated Sucessfully'
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

    private def college_params
        params.require(:college).permit(:name, :address, :contact_no, :email_id, :website_link) 
    end
      
end
