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

form do |f|
  f.inputs do
    f.input :user, as: :select, collection: User.all.map{|u| [u.email, u.id]}
    f.input :name
    f.input :address
    f.input :contact_no
    f.input :sslc_percentage
    f.input :hsc_diplomo
    f.input :hsc_diplomo_percentage
    f.input :email_id
  end
  f.actions
end

filter :name
filter :address
end
