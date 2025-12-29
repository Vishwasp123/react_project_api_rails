class PasswordMailer < ApplicationMailer

	def forgotpassword(user)
		@user = user
		@reset_url = "#{ENV['FRONTEND_URL']}/reset-password?token=#{user.reset_token}"


		mail(
			to: @user.email, 
			subject: "Reset You email password"
		)
	end 

end
