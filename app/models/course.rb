class Course < ApplicationRecord
  belongs_to :college
  has_many :students, dependent: :destroy

  validates :name, :presence => true
  
end
 