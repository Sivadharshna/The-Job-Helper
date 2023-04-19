class Job < ApplicationRecord 
  
  belongs_to :company

  has_many :individual_applications,  dependent: :destroy
  has_many :individuals , :through => :individual_applications

  validates :name, :salary, :minimum_educational_qualification, :presence => true
  validates :salary, numericality: { greater_than: 0 }

end
 