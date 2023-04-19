class IndividualApplication < ApplicationRecord
  belongs_to :individual
  belongs_to :job

  has_one :accepted_offer, :as => :approval, dependent: :destroy

  has_one :job_detail, :through => :accepted_offer ,dependent: :destroy

  attribute :status, default: 'Under Progress'

  validates_uniqueness_of :individual_id , scope: [ :job_id ]
end
