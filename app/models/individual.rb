class Individual < ApplicationRecord
  belongs_to :user

  has_many :individual_applications ,dependent: :destroy
  has_many :jobs, :through => :individual_applications
  has_one_attached :resume

  validates :name ,:email_id, :contact_no, :sslc_percentage, :hsc_diplomo, :hsc_diplomo_percentage , :presence => true
  validates :email_id, :user_id, :uniqueness => true
  validates :email_id, :format => { with: URI::MailTo::EMAIL_REGEXP }
  validates :contact_no , :format => { :with => /\A\d+\z/ }, :length => { :minimum => 10 , :maximum => 10}
  validates_inclusion_of :hsc_diplomo, in: ['HSC', 'DIPLOMO']

  
  before_validation :case_convert

  def case_convert
    if self.hsc_diplomo != nil
      self.hsc_diplomo.upcase!
    end
  end

  before_validation :remove_trailing_spaces

  def remove_trailing_spaces
    self.name.squish!
    self.email_id.squish!
    self.contact_no .squish!
  end
end
   