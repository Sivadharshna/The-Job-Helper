module Api
    module V1
        class JobsController < Api::ApplicationController
            before_action :doorkeeper_authorize!


            before_action :check_user , only: [:new, :create, :edit, :update, :destroy]

            def check_user
                if current_user.present? && current_user.role!='company'
                    render json: 'Restricted Access', status: 403
                end
            end

            before_action :check_user_view, only: [:index, :show, :specific]
            
            def check_user_view
                if current_user.present? && current_user.role=='college'
                    render json: 'Restricted Access', status: 403
                end
            end

            #--------------------------------------------------------------------#
            def specific
                if current_user.present?
                    if current_user.role=='company' 
                        @jobs=Job.where(company_id: current_user.company.id)
                        if @jobs
                            render json: @job, status: 200 #OK
                        else
                            render json: 'Not found', status: 404 # resource not found'
                        end
                    elsif current_user.role=='individual' 
                        @jobs=Job.where( "minimum_educational_qualification LIKE ?",  "%"+current_user.individual.bachelors_degree+"%" ).or(Job.where("minimum_educational_qualification LIKE ?", "%Any degree%" ))
                        if @jobs
                            render json: @jobs, status: 200
                        else
                            render json: 'Oops! Sorry. Try searching all jobs', status: 404
                        end
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    render json: 'No user', status: 302
                end
            end

            def index
                if current_user.present?
                    if current_user.role=='individual'
                        @jobs=Job.all
                        if @jobs
                            render json: @jobs, status: 200
                        else
                            render json: 'Not found', status: 404
                        end
                    else
                        render json: 'Restricted Access', status: 403
                    end
                else
                    redirect_to root_path
                end
            end
            
            def show
                @job=Job.find_by(id: params[:id])
                if @job
                    render json: @job, status: 200
                else
                    render json: 'Not found', status: 404 # resource not found
                end
            end

            def update
                if current_user.company.id==params[:company_id].to_i
                    @job=Job.find_by(id: params[:id])
                    if @job
                        if @job.company_id==params[:company_id].to_i
                            if @job.update(job_params)
                                render json: 'Updated Successfully'
                            else
                                render json:  @job.errors  , status: 422
                            end
                        else
                            render json: ' Restricted Access', status: 403 # forbidden access
                        end
                    else
                        render json:'Not found', status: 404 # resource not found
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end

            def create
                @job=Job.new(job_params)
                @job.company_id=current_user.company.id
                if @job.save
                    render json: @job, status: 200 #OK
                else
                    render json: @job.errors, status: 422
                end   
            end

            def destroy
                @job=Job.find_by(id: params[:id])
                if @job
                    if @job.company_id==current_user.company.id.to_i
                        if @job.destroy
                            render json: 'Deleted Successfully'
                        else
                            render json: @job.errors
                        end
                    else
                        render json: 'Restricted Access', status: 403 #forbidden access
                    end
                else
                    render json: 'Not found', status: 404 # resource not found
                end
            end



            private def job_params
                params.require(:job).permit(:name,:description,:salary,:minimum_experience,:expected_sslc_percentage , :expected_hsc_percentage,:expected_cgpa,:mode, :minimum_educational_qualification)
            end
        end
    end 
end