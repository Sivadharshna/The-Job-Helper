module Api
    module V1
        class CompaniesController < ApplicationController
            before_action :doorkeeper_authorize!

            before_action :check_user , only: [:new, :create, :edit, :update, :select_students]
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
                @company=Company.find_by(id: params[:id])
                if @company
                    render json: @company, status: 200
                else
                    render json:{ error: 'Not found' }, status: 404
                end
            end

            def update
                @company=Company.find_by(id: params[:id])
                if @company
                    if @company.update(company_params)
                        render json: 'Updated Successfully'
                    else
                        render json: @company.errors, status: 422
                    end
                else
                    render json: { error: 'Not found' }, status: 404
                end
            end

            def create
                @company=Company.new(company_params)
                @company.user_id=current_user.id
                if @company.save
                    render json: @company, status: 200
                else
                    render json: @company.errors, status: 422
                end   
            end

=begin
            def destroy
                @company=Company.find_by(id: params[:id])
                if @company
                    if @company.destroy
                        render json: 'Deleted Successfully', status: 200
                    else
                        render json: @company.errors
                    end
                else
                    render json: {error: 'Not found' }, status: 404
                end
            end
=end
            def select_students
                @company=Company.find(params[:company_id])
                if @company
                    @student=Student.find(params[:student_id])
                    
                    if check_student_not_selected(@company , @student)==true
                        if @company.students << @student
                            render json: 'Selected Successfully', status: 200
                        else
                            render json: 'Please try Again' , status: 500 #Internal server error
                        end
                    else
                        render json: 'Already selected', status: 409 #conflict 
                    end
                else
        
                end
            end
        
            private def check_student_not_selected(company, student)
                if company.students.exists?(student.id)==true
                    return false
                else
                    return true
                end
            end
        
            private def company_params
                params.require(:company).permit(:name, :description, :address, :website_link, :contact_no, :email_id)
            end

        end
    end
end