ActiveAdmin.register JobDetail do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :accepted_offer_id, :result
  #
  # or
  #
  # permit_params do
  #   permitted = [:accepted_offer_id, :result]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  index do
    column :name do | job_detail |
      link_to job_detail.accepted_offer.approval.individual.name, admin_individual_path(job_detail.accepted_offer.approval.individual)
    end
    column :job do | job_detail |
      link_to job_detail.accepted_offer.approval.job.name, admin_job_path(job_detail.accepted_offer.approval.job)
    end
    column :company do | job_detail |
      link_to job_detail.accepted_offer.approval.job.company.name, admin_company_path(job_detail.accepted_offer.approval.job.company)
    end
    column :result
  end

end
