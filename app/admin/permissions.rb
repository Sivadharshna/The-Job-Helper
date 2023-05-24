ActiveAdmin.register Permission do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  #
  # or
  #
  # permit_params do
  #   permitted = [:status, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column :user
    column :status
    column 'Profile', :user_name do | permission |
      if permission.user.role=='college'
        link_to permission.user.college.name, admin_college_path(permission.user.college)
      elsif permission.user.role=='company'
        link_to permission.user.company.name , admin_company_path(permission.user.company)
      end
    end
    column :created_at
    column :updated_at
    actions
 end

  form do |f|
    f.inputs "Permission" do
      f.input :status, as: :select, collection: ["Permitted", "Denied"]
    end
    f.actions
  end 

  config.remove_action_item (:new)
  
  permit_params :status

  filter :user , :as => :select, :collection => User.all.map{|u| [u.email, u.id]}
  filter :status , :as => :select, :collection => [ 'Permitted' , 'Denied', 'Under progress' ]
end
