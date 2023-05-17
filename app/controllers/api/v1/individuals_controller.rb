module Api
    module V1
        class IndividualsController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            
            before_action :check_user , only: [:new, :create, :edit, :update]

            before_action :check_user_show, only: [:show]

            before_action :check_permission

            def check_permission
                if current_user.role!='individual' && current_user.permission.status!='Permitted' 
                    render json: 'You need admins permssion to access', status: 403
                end
            end

            def check_user_show
                if current_user.present? && current_user.role=='college'
                    render json: 'Restricted Access', status: 403
                end
            end
        
            def check_user
                if current_user.present? && current_user.role!='individual'
                    render json: 'Restricted Access', status: 403
                end
            end
            
            def show
                if current_user.role=='individual' && current_user.individual.id==params[:id].to_i
                    @individual=Individual.find_by(id: params[:id])
                    if @individual
                        render json: @individual, status: 200
                    else
                        render json: 'Not found' , status: 404
                    end 
                elsif current_user.role=='company'  
                    @company=Company.find(current_user.company.id)
                    @individual=Individual.find_by(id: params[:id])
                    if @individual
                        if !(@individual.individual_applications.where(jobs: @company.jobs).empty?)
                            render json: @individual , status: 200
                        else
                            render json: 'Restricted Access', status: 403
                        end
                    else
                        render json: 'Not Found', status: 404
                    end
                else
                    render json: 'Restricted Access', status: 403
                end
            end

            def update
                if current_user.role=='individual' && current_user.individual.id==params[:id].to_i
                    @individual=Individual.find_by(id: params[:id])
                    if @individual
                        if @individual.update(individual_params)
                            render json: 'Updated Successfully'
                        else
                            render json: @individual.errors, status: 422
                        end
                    else
                        render json:  'Not found' , status: 404
                    end
                else
                    render json: 'Restricted Access', status: 403
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
                        render json: @individual, status: 200
                    else
                        render json: @individual.errors, status: 422
                    end 
                else
                    render json: 'No user', status: 302 
                end 
            end

            private def individual_params
                params.require(:individual).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :experiece, :address, :age,  :bachelors_degree, :masters_degree, :contact_no, :email_id)
            end
        end
    end
end