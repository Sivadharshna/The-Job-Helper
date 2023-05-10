class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    if current_user.present?
      if current_user.role =='company'
        @company=Company.find_by( user_id: current_user.id)
        if @company==nil
           redirect_to '/companies/new'
        end
      elsif current_user.role=='individual'
        @individual=Individual.find_by(user_id: current_user.id)
        if @individual==nil
          redirect_to '/individuals/new'
        end
      elsif current_user.role=='college'
        @college=College.find_by(user_id: current_user.id)
        if @college==nil
          redirect_to '/colleges/new'
        else
          @courses=Course.all.where(college_id: @college.id)
          @students=Student.where(course_id: @courses)
        end
      end

    end
  end
end 
