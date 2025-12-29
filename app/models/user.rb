class User < ApplicationRecord

	has_secure_password
    before_validation :downcase_email

	before_validation :normalize_phone_number

	validates  :phone_number , presence: true 
    validate :phone_number_validation
    validates :email, presence: true, 
            uniqueness: { case_sensitive: false }, 
            format: {
              with: URI::MailTo::EMAIL_REGEXP,
              message: "is not a valid email"
            }
    


  

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

  #normalization phone number 
  def normalize_phone_number
  	return if phone_number.blank?
  	formatted = phone_number.start_with?("+") ? phone_number: "+#{phone_number}"
  	phone = Phonelib.parse(formatted)

  	#Save always in E.164 format (+919874563210)
  	self.phone_number = phone.e164 if phone.valid?
  end 

  #phone number validation all country 

  def phone_number_validation
  	phone = Phonelib.parse(phone_number)
  	unless phone.valid?
  		errors.add(:phone_number, "is not valid phone_number")
  	end 	

  	if phone.country == "IN" && phone.national_number.length != 10
  		errors.add(:phone_number , "must be 10 digit for India")	
  	end
  end  
end

