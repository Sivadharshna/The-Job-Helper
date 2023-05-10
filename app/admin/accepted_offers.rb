ActiveAdmin.register AcceptedOffer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :schedule, :approval_type, :approval_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:schedule, :approval_type, :approval_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
index do
  column :approval_type
  column :approval
  actions
end

scope :all
scope :college_applications
scope :individual_applications

config.remove_action_item (:new)
end
