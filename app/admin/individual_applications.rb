ActiveAdmin.register IndividualApplication do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :individual_id, :job_id, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:individual_id, :job_id, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
      index do
        column :individual.name
        column 'Job', :job_name do | individual_application |
          link_to individual_application.job.name+' - '+individual_application.job.company.name, admin_job_path(individual_application.job)
        end
        column :status
      end

      filter :individual
      filter :job
      filter :status

end
