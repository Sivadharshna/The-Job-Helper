ActiveAdmin.register CollegeApplication do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :college_id, :company_id, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:college_id, :company_id, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

    index do
        column :company.name
        column :college.name
        column :status
    end

    filter :college
    filter :company
    filter :status
end
