class AcceptedOffer < ApplicationRecord
  belongs_to :approval, :polymorphic => true

  validates_uniqueness_of :approval_id, :scope => [:approval_id, :approval_type], :message => 'cannot be duplicated'
  validates_presence_of :schedule
  #validates :schedule, :inclusion => { (in: Date.today+1) }
  validates :schedule, :date => { :after => Time.now }
  #validates_inclusion_of :schedule, in:  {Date.today+1}

  
end
 