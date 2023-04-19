module Api
    module V1
        class IndividualApplicationsController < Api::ApplicationController
            before_action :doorkeeper_authorize!

            before_action :check_user , only: [:new, :create, :edit, :update]

            def check_user
                if current_user.present? && current_user.role!='individual'
                    flash[:notice]='Restricted Access'
                    redirect_to root_path
                end
            end

            def index
                if current_user.role=='company' || current_user.role=='individual'
                    @individual_applications=IndividualApplication.all
                    if @individual_applications
                        if current_user.role=='company' && (Job.find(params[:job_id]).company_id==params[:company_id])
                            @individual_applications=IndividualApplication.where(job_id: params[:job_id])
                            if @individual_applications
                                render json: @individual_applications, status: 200
                            else
                                render json: 'No applications found' ,status: 404
                            end
                        elsif current_user.role=='individual'
                            #@individual_applications=IndividualApplications.joins(:individual)
                            sql="SELECT individuals.name, companies.name, jobs.name FROM individual_applications INNER JOIN individuals ON individuals.id=individual_applications.id INNER JOIN jobs ON jobs.id=individual_applications.job_id INNER JOIN companies ON company.id=jobs.company_id WHERE individuals.id="+params[:individual_id].to_s
                            @individual_applications=IndividualApplication.connection.select_all(sql)
                            if @individual_applications
                                render json: @individual_applications, status: 200
                            else
                                render json: { error: 'Not found' }, status: 404
                            end
                        else
                            render json: 'Restricted Access' ,status: 403
                        end
                    else
                        render json: 'No applications found' , status: 404
                    end
                    
                else
                    render json: 'Restricted Access' , status: 403
                end

            end
            
            def create
                @individual_application=IndividualApplication.new
                @individual_application.individual_id=current_user.individual.id
                @individual_application.job_id=params[:job_id]
                if @individual_application.save
                    render json: 'Applied Successfully', status: 200
                else
                    render json: @individual_application.errors, status: 422
                end   
            end

        end
    end
end
