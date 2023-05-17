class IndividualApplicationsController < ApplicationController

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
        if current_user.present? && current_user.role!='individual'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    def index 
        if current_user.present? 
            if current_user.role=='individual' && current_user.individual.id==params[:individual_id].to_i
                @individual_applications=IndividualApplication.where(individual_id: current_user.individual.id).and(IndividualApplication.where(status: 'Under Progress').or(IndividualApplication.where(status: 'Rejected')) )
            elsif current_user.role=='company' && current_user.company.id==params[:company_id].to_i
                #http://localhost:3000/companies/1/jobs/4/individual_applications?
                @job=Job.find(params[:job_id])
                if @job
                    if @job.company.id==current_user.company.id
                        @individual_applications=IndividualApplication.where(job_id: params[:job_id]).and(IndividualApplication.where(status: 'Under Progress') )
                    else
                        flash[:notice]='Restricted Access'
                        redirect_to root_path
                    end
                else
                    flash[:notice]='Job doesn\'t exists'
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

    def create
        if current_user.present? && current_user.role='individual'
            @individual_application=IndividualApplication.new
            @individual_application.individual_id=current_user.individual.id
            @job=Job.find_by(id: params[:job_id])
                if @job
                    @individual_application.job_id=params[:job_id] 
                    if @individual_application.save
                        flash[:notice]="Applied Successfully !"
                    else
                        flash[:notice]="Sorry! You have already applied for the job"
                    end
                else
                    flash[:notice]='Job not found'
                end
                redirect_to root_path
        else
            flash[:notice]='Restricted Access'
            redirect_to root-path
        end
    end

    def update
        if current_user.role=='company'
            @ia=IndividualApplication.find_by(id: params[:id])
            if @ia && current_user.company.id==@ia.job.company.id
                @ia.update(status: 'Rejected')
                flash[:notice]='Rejected Successfully'
                redirect_to '/companies/'+@ia.job.company.id.to_s+'/jobs/'+@ia.job.id.to_s+'/individual_applications'
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
        if current_user.role=='individual'
            @ia=IndividualApplication.find_by(id: params[:id])
            if @ia && @ia.individual.id==current_user.individual.id
                if @ia.status=='Rejected'
                    @ia.destroy
                    flash[:notice]='Deleted Application'
                    redirect_to '/individual/'+current_user.individual.id.to_s+'/individual_applications'
                else
                    flash[:notice]='Cannot be Deleted'
                    redirect_to '/individual/'+current_user.individual.id.to_s+'/individual_applications'
                end
            else
                flash[:notice]='Restricted Access'
                redirect_to '/individual/'+current_user.individual.id.to_s+'/individual_applications'
            end
        else
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end

end
