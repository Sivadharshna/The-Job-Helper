class College < ApplicationRecord
  belongs_to :user
  has_many :courses, dependent: :destroy
  has_many :college_applications, dependent: :destroy
  has_many :companies, :through => :college_applications

  has_one_attached :photo
  
  validates :name, :email_id, :user_id, :uniqueness =>true
  validates_associated :courses
  validates :email_id, :format => { with: URI::MailTo::EMAIL_REGEXP }
  validates :name,:email_id,:contact_no,:address, :presence => true
  validates :contact_no , :format => { :with => /\A\d+\z/ } , :length => { :minimum => 10, :maximum => 15 }

  before_validation :remove_trailing_spaces

  def remove_trailing_spaces
    self.name.squish!
    self.email_id.squish!
    self.contact_no .squish!
    self.address.squish!
  end

  #Individual.joins(:individual_applications).count > 1 
end
 