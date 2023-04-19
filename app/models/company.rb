class Company < ApplicationRecord
  belongs_to :user
  has_many :jobs, dependent: :destroy

  has_and_belongs_to_many :students, dependent: :destroy

  has_many :college_applications, dependent: :destroy
  has_many :colleges, :through => :college_applications

  validates :name, :uniqueness => { :case_sensitive => false }, :presence=> true
  validates :email_id, :user_id, :uniqueness => { :case_sensitive => false }
  #validates :contact_no , :format => { :with => /\A\d+\z/ } , :length => { :minimum => 10, :maximum => 15 }

  validates :contact_no , :format => { :with => /\A\d+\z/ } , :length => { :minimum=> 10 , :maximum=> 15}
  validates :email_id , :format => { with: URI::MailTo::EMAIL_REGEXP }, :presence => true
  
  before_validation :remove_trailing_spaces

  def remove_trailing_spaces
    self.name.squish!
    self.email_id.squish!
    self.contact_no.squish!
    self.address.squish!
  end
end
 