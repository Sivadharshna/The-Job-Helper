ActiveAdmin.register Job do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :salary, :minimum_experience, :mode, :minimum_educational_qualification, :expected_sslc_percentage, :expected_hsc_percentage, :expected_cgpa, :company_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :salary, :minimum_experience, :mode, :minimum_educational_qualification, :expected_sslc_percentage, :expected_hsc_percentage, :expected_cgpa, :company_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
    index do
      column :name do |job|
        link_to job.name, admin_job_path(job)
      end
      column :company
      column :salary
      actions
    end

    config.remove_action_item (:new)

    filter :individuals
    filter :name
    filter :company
    filter :salary
end
