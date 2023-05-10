module Api
    module V1
        class CompaniesController < ApplicationController
            before_action :doorkeeper_authorize!

            before_action :check_user , only: [:new, :create, :edit, :update]
            before_action :check_user_index, only: [:index]

            private def check_user_index
                if current_user.present? && current_user.role!='college'
                    render json: 'Restricted Access' , status: 403
                end
            end

            def check_user
                if current_user.present? && current_user.role!='company'
                    render json: 'Restricted Access' , status: 403
                end
            end

            def index
                @companies=Company.all
                if @companies
                    render json: @companies, status: 200
                else
                    render json: 'Not found', status: 404
                end
            end
            
            def show
                if current_user.present? 
                    if current_user.role=='company'
                        if current_user.company.id==params[:id].to_i
                            @company=Company.find_by(id: params[:id])
                            if @company
                                render json: @company, status: 200
                            else
                                render json:{ error: 'Not found' }, status: 404
                            end
                        else
                            render json: 'Restricted Access', status: 403
                        end
                    else
                        @company=Company.find_by(id: params[:id])
                        if @company
                            render json: @company, status: 200
                        else
                            render json:{ error: 'Not found' }, status: 404
                        end
                    end
                else
                    render json: 'No user', status: 302
                end
            end

            def update
                if current_user.present?
                    if current_user.role=='company' && current_user.company.id==params[:company_id].to_i
                        @company=Company.find_by(id: params[:id])
                        if @company
                            if @company.update(company_params)
                                render json: 'Updated Successfully'
                            else
                                render json: { error: @company.errors } , status: 422
                            end
                        else
                            render json: 'Not found' , status: 404
                        end
                    else
                        render json: 'Restricted Access' , status: 403
                    end
                else
                    render json: 'No user', status: 302
                end
            end

            def create
                if current_user.present?
                    @company=Company.new(company_params)
                    @company.user_id=current_user.id
                    if @company.save
                        @permission=Permission.new
                        @permission.user_id=current_user.id
                        @permission.save
                        render json: @company, status: 200
                    else
                        render json: @company.errors, status: 422
                    end 
                else
                    render json: 'No user' , status: 302
                end  
            end

        
            private def company_params
                params.require(:company).permit(:name, :description, :address, :website_link, :contact_no, :email_id)
            end

        end
    end
end