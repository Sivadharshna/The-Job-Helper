class JobsController < ApplicationController
     
    ####
    #callbacks
    before_action :check_user , only: [:new, :create, :edit, :update]

    #callback methods
    def check_user
        if current_user.present? && current_user.role!='company'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

    def index
        if current_user.present?
            if current_user.role=='company'
                if current_user.company.id==params[:company_id].to_i
                    @jobs=Job.all.where(company_id: params[:company_id])
                end
            elsif current_user.role=='individual' && current_user.individual.id==params[:individual_id].to_i
                @jobs=Job.all.where( "minimum_educational_qualification LIKE ?",  "%"+current_user.individual.bachelors_degree+"%" ).or(Job.where("minimum_educational_qualification LIKE ?", "%Any degree%" ))
            else
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
        @company = Company.find(params[:company_id])
    end
    def create
        @job=Job.new(job_params)
        @job.company_id=params[:company_id]
        if @job.save
            redirect_to '/companies/'+params[:company_id].to_s+'/jobs'
        else
            render :new, status: :unprocessable_entity
        end
    end
    
    def edit
        @job=Job.find(params[:id])
        @company= Company.find(params[:company_id])
    end
    def update
        @job=Job.find(params[:id])
        if @job.update(job_params)
            redirect_to '/companies/'+@job.company_id.to_s+'/jobs/'+@job.id.to_s 
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @job=Job.find(params[:id])
        @job.destroy
        redirect_to request.referer
    end

    private def job_params
        params.require(:job).permit(:name,:description,:salary,:minimum_experience,:expected_sslc_percentage , :expected_hsc_percentage,:expected_cgpa,:mode, :minimum_educational_qualification)
    end
end
