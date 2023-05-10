ActiveAdmin.register Student do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :cgpa, :graduation_year, :placement_status, :course_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :cgpa, :graduation_year, :placement_status, :course_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


    index do
       column :name
       column :course
       column :hsc_diplomo
       column :graduation_year
       column :placement_status
       actions
    end

    config.remove_action_item (:new)

    filter :course
    filter :hsc_diplomo
    filter :graduation_year
    filter :placement_status

end
