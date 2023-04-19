module Api
    module V1
        class IndividualsController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            ####
            #callbacks
            before_action :check_user , only: [:new, :create, :edit, :update]

            #callback methods
            def check_user
                if current_user.present? && current_user.role!='individual'
                    render json: 'Restricted Access', status: 403
                    redirect_to root_path
                end
            end
            
            def show
                @individual=Individual.find_by(id: params[:id])
                if @individual
                    render json: @individual, status: 200
                else
                    render json:{ error: 'Not found' }, status: 404
                end
            end

            def update
                @individual=Individual.find_by(id: params[:id])
                if @individual
                    if @individual.update(individual_params)
                        render json: 'Updated Successfully'
                    else
                        render json: @individual.errors, status: 422
                    end
                else
                    render json: { error: 'Not found' }, status: 404
                end
            end

            def create
                @individual=Individual.new(individual_params)
                @individual.user_id=current_user.id
                if @individual.save
                    render json: @individual, status: 200
                else
                    render json: @individual.errors, status: 422
                end   
            end

            def destroy
                @individual=Individual.find_by(id: params[:id])
                if @individual
                    if @individual.destroy
                        render json: 'Deleted Successfully', status: 204
                    else
                        render json: 'Oops! Something went wrong', status: 500 
                    end
                else
                    render json: 'Not found', status: 404
                end
            end


            private def individual_params
                params.require(:individual).permit(:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :experiece, :address, :age,  :bachelors_degree, :masters_degree, :contact_no, :email_id)
            end
        end
    end
end