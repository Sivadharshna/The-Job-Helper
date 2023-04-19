class User < ApplicationRecord


  validates :email, format: URI::MailTo::EMAIL_REGEXP

  def self.authenticate(email,password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil

    #user && user.valid_password
  end


  has_one :company , dependent: :destroy
  has_one :individual, dependent: :destroy
  has_one :college, dependent: :destroy
  has_one :permission, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
