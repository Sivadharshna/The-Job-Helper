class JobsController < ApplicationController
     

    before_action :check_user , only: [:new, :create, :edit, :update, :destroy]
    before_action :authenticate_user!

    def check_user
        if current_user.present? && current_user.role!='company'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    before_action :check_user_view, only: [:index, :show, :specific]
            
    def check_user_view
        if current_user.present? && current_user.role=='college'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def specific
        if current_user.present?
            if current_user.role=='company'
                @jobs=Job.all.where(company_id: current_user.company.id)
            elsif current_user.role=='individual'
                @jobs=Job.all.where( "minimum_educational_qualification LIKE ?",  "%"+current_user.individual.bachelors_degree+"%" ).or(Job.where("minimum_educational_qualification LIKE ?", "%Any degree%" ))
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end       
    end

    def index
        if current_user.present?
            if current_user.role=='individual'
                @jobs=Job.all
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            redirect_to root_path
        end
    end
    
    def show
        @job=Job.find(params[:id])
    end

    def new
        @job=Job.new
        @company=Company.find(current_user.company.id)
    end
    def create
        @job=Job.new(job_params)
        @company=Company.find(current_user.company.id)
        @job.company_id=current_user.company.id
        if @job.save
            flash[:notice]='Saved Successfully'
            redirect_to '/jobs/specific'
        else
            render :new, status: :unprocessable_entity
        end
    end
    
    def edit
        if current_user.company.id==params[:company_id].to_i
            @job=Job.find(params[:id])
            @company=Company.find(current_user.company.id)
            if @job
                render :edit
            else
                flash[:notice]='Profile not found'
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end   
    end
    def update
        if current_user.company.id==params[:company_id].to_i 
            @job=Job.find(params[:id])
            @company=Company.find(current_user.company.id)
            if @job && @job.company_id==params[:company_id].to_i
                if @job.update(job_params)
                    flash[:notice]='Updated Successfully'
                    redirect_to '/companies/'+@job.company_id.to_s+'/jobs/'+@job.id.to_s 
                else
                    render :edit, status: :unprocessable_entity
                end
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
        @job=Job.find(params[:id])
        if @job
            if @job.company_id==current_user.company.id
                if @job.destroy
                    flash[:notice]='Deleted Successfully'
                    redirect_to '/jobs/specific'
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to root_path
            end
        else
            flash[:notice]='Not found'
        end
    end

    private def job_params
        params.require(:job).permit(:name,:description,:salary,:minimum_experience,:expected_sslc_percentage , :expected_hsc_percentage,:expected_cgpa,:mode, :minimum_educational_qualification)
    end
end
