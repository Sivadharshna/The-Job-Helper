ActiveAdmin.register Individual do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email_id, :address, :age, :contact_no, :experience, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :bachelors_degree, :masters_degree, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email_id, :address, :age, :contact_no, :experience, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :bachelors_degree, :masters_degree, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


index do
    column :id
    column :name
    column :address
    column :contact_no
    column :email_id
    actions
end

filter :name
filter :address
end
