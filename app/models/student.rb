class Student < ApplicationRecord
  belongs_to :course
  has_and_belongs_to_many :companies

  validates :name , :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage, :graduation_year, :cgpa, :presence => true 
  validates :graduation_year , :length => { :minimum=>4 , :maximum=>4} , :numericality => { greater_than_or_equal_to: Time.now.year } 

  validates_inclusion_of :hsc_diplomo, in: ['HSC', 'DIPLOMO']
  validates :sslc_percentage,:hsc_diplomo_percentage,:cgpa, numericality: { greater_than: 0 }


  before_validation :case_convert
  def case_convert
    if hsc_diplomo
      self.hsc_diplomo.upcase!
    end
  end

end
 