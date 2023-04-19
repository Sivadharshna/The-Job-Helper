class CollegeApplication < ApplicationRecord
  belongs_to :college
  belongs_to :company

  has_one :accepted_offer, :as => :approval, dependent: :destroy

  attribute :status, default: 'Under progress'
   
end
