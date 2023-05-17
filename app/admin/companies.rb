ActiveAdmin.register Company do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :contact_no, :address, :website_link, :email_id, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :contact_no, :address, :website_link, :email_id, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

index do
    column :name
    column :address
    column :contact_no
    column :website_link
    column :email_id
    actions 
end

form do |f|
  f.inputs do
    f.input :user, as: :select, collection: User.all.map{|u| [u.email, u.id]}
    f.input :name
    f.input :address
    f.input :contact_no
    f.input :website_link
    f.input :email_id
  end
  f.actions
end


filter :name
filter :address
filter :email_id
  
end
