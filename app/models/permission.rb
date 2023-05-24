class Permission < ApplicationRecord
  belongs_to :user
  attribute :status, default: 'Yet to be approved'


  

end