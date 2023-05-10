class IndividualApplicationsController < ApplicationController

    before_action :authenticate_user!
    before_action :check_user , only: [:new, :create, :edit, :update]

    before_action :authenticate_user!
    def check_user
        if current_user.present? && current_user.role!='individual'
            flash[:notice]='Restricted Access'
            redirect_to root_path
        end
    end


    def index 
        if current_user.present? 
            if current_user.role=='individual' && current_user.individual.id==params[:individual_id].to_i
                @individual_applications=IndividualApplication.where(individual_id: current_user.individual.id).and(IndividualApplication.where(status: 'Under Progress') )
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
            @individual_application.job_id=params[:job_id]
            if @individual_application.save
                flash[:notice]="Applied Successfully !"
            else
                flash[:notice]="Sorry! You have already applied for the job"
            end
            redirect_to root_path
        else
            flash[:notice]='Restricted Access'
            redirect_to root-path
        end
    end

end
