class JobDetail < ApplicationRecord
  belongs_to :accepted_offer 

  validates :accepted_offer_id, :uniqueness => true
end
