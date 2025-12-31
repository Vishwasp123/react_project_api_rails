class AuthController < ApplicationController
	# skip_before_action :authorized, only: [:login]
	skip_before_action :verify_authenticity_token

	rescue_from	ActiveRecord::RecordNotFound, with: :handle_record_not_found

	def login
	  user = User.find_by(email: login_params[:email])

	  if user && user.authenticate(login_params[:password])
	    token = encode_token(user_id: user.id)

	    render json: {
	      message: "Login successful",
	      user: {
	        id: user.id,
	        username: user.username,
	        email: user.email
	      },
	      token: token
	    }, status: :ok
	  else
	    render json: {
	      errors: {
	        base: ["Invalid email or password"]
	      }
	    }, status: :unauthorized
	  end
	end


	def logout
  	  token = request.headers['token']

	  if token.present?
	    BlacklistedToken.create!(token: token)
	    render json: { message: 'Logged out successfully' }, status: :ok
	  else
	    render json: { error: 'Token not provided' }, status: :unauthorized
	  end
	end

	def forgot_password
		
	  @user = User.find_by(email: params[:email])
	  
	  if @user
	  	
	  	token = @user.generate_reset_token
	  	PasswordMailer.forgotpassword(@user).deliver_now
	    render json: {message: "you will receive a password reset link", token: @user.reset_token}, status: :ok
	  else token
	  	render json: { error: "User not found" }, status: :not_found
	  end
	end

	def reset_password
		
		@user = User.find_by(reset_token: request.headers['token'])
		

		return render json: {error: "Invalid Token"}, status: :unprocessable_entity unless @user

		if @user.update(
			password: params[:password], 
			password_confirmation: params[:password_confirmation], 
			reset_token: nil
			)
			render json: {
				message: "Password reset successfully"
			}, status: :ok 
	  	else
	  		
	  		render json: {error: @user.errors.full_messages}, 
	  		status: :unprocessable_entity 

			@user.update(
				password: params[:password],
				password_confirmation: params[:password_confirmation],
				reset_token: nil
			)	
		end
	end 

	private

	def login_params
		params.require(:user).permit(:email, :password)
	end

	def handle_record_not_found(e)
		render json: {message: "User doesn't exist"}, status: :unauthorized
	end
end
