class CollegeApplication < ApplicationRecord
  belongs_to :college
  belongs_to :company

  has_one :accepted_offer, :as => :approval, dependent: :destroy
  has_and_belongs_to_many :students

  attribute :status, default: 'Under progress'
   
end
