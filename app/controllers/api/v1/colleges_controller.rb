module Api
    module V1
        class CollegesController < Api::ApplicationController
            before_action :doorkeeper_authorize!
            
            
            before_action :check_user , only: [:new, :create, :edit, :update]
            before_action :check_user_show, only: [:show]

            def check_user_show
                if current_user.present? && current_user.role=='individual'
                    render json: 'Restricted Access' , status: 403
                end
            end
            
            def check_user
                if current_user.present? && current_user.role!='college'
                    render json: 'Restricted Access' , status: 403
                end
            end

            
            def show
                @college=College.find_by(id: params[:id])
                if @college
                    render json: @college, status: 200
                else
                    render json:{ error: 'Not found' }
                end
            end

            def update
                @college=College.find_by(id: params[:id])
                if @college
                    if @college.update(college_params)
                        render json: 'Updated Successfully'
                    else
                        render json: @college.errors
                    end
                else
                    render json: { error: 'Not found' }
                end
            end

            def create
                @college=College.new(college_params)
                @college.user_id=current_user.id
                if @college.save
                    render json: @college, status: 200
                else
                    render json: @college.errors
                end   
            end
=begin
            def destroy
                @college=College.find_by(id: params[:id])
                if @college
                    if @college.destroy
                        render json: 'Deleted Successfully'
                    else
                        render json: @college.errors
                    end
                else
                    render json: 'Not found'
                end
            end

=end
            private def college_params
                params.require(:college).permit(:name, :address, :contact_no, :email_id, :website_link) 
            end
            
        end
    end
end
