ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :role, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:role, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :role

  index do
    column :id
    column :role
    column :email do | user |
      if user.role=='college'
        link_to user.email , admin_college_path(user.college)
      elsif user.role=='individual'
        link_to user.email, admin_individual_path(user.individual)
      elsif user.role=='company'
        link_to user.email , admin_company_path(user.company)
      end
    end
    column :created_at
    column :updated_at
    actions
 end

  
  
end
