class User < ApplicationRecord

	has_secure_password
  before_validation :downcase_email

	validates :email,
          presence: { message: "is required" }

  validates :email,
            format: {
              with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i,
              message: "is not a valid email",
              allow_blank: true
            }

  validates :email,
            uniqueness: { case_sensitive: false },
            if: -> { email.present? }


  validates  :username,:phone_number, :password, :country_code , presence: true ,   if: :normal_signup?

  validate :phone_number_validation,
           if: -> { normal_signup? && phone_number.present? && country_code.present? }




  def normal_signup?
    provider.blank?
  end 

  def email_required?
     provider.blank? || provider == "google"
  end
  

	def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "id_value", "password_digest", "	updated_at", "username", "phone_number"]
  end

  #forgot passssword ke time token generate 
  def generate_reset_token
    update!(reset_token: SecureRandom.hex(20))
  end 

  private 

  def downcase_email
    self.email = email.to_s.downcase
  end 

  #phone number validation all country 

  def phone_number_validation
    full_phone_number = "#{country_code}#{phone_number}"
  	phone = Phonelib.parse(full_phone_number)
  	unless phone.valid?
  		errors.add(:phone_number, "is not valid phone_number for #{country_code}")
  	end 	
  end  
end

