ActiveAdmin.register College do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email_id, :contact_no, :address, :website_link, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email_id, :contact_no, :address, :website_link, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


      index do
          column :id
          column :name
          column :email_id
          column :website_link
          column :contact_no
          column :address
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
