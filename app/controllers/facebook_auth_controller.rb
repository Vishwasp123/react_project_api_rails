class FacebookAuthController < ApplicationController

	skip_before_action :verify_authenticity_token

	def facebook_login
		
		payload = fetch_facebook_payload(params[:access_token])
		return unauthorized("Invalid facebook token") if payload["error"]

		user = find_or_create_facebook_user(payload)

		token = JWT.encode(
			{user_id: user.id, exp: 24.hours.from_now.to_i}, 
			Rails.application.secret_key_base, "HS256"
		)

		render json:{
			message: "Facebook Login successful", 
			token: token, 
			user: {
				id: user.id, 
				email: user.email, 
				username: user.username,
				provider: user.provider, 
				uid: user.uid 
			}, 
			user_details: UserSerializer.new(user),
			facebook_response: payload
		}, status: :ok
	end 

	private

	def fetch_facebook_payload(access_token)
		
		return {error: "Token missing"} if access_token.blank?

		uri = URI(
		  "https://graph.facebook.com/v24.0/me" \
		  "?fields=#{params["fields"]}" \
		  "&access_token=#{access_token}"
		)

    JSON.parse(Net::HTTP.get(uri))
  	rescue StandardError => e
    { "error" => e.message }
	end

	def find_or_create_facebook_user(payload)
		
		user = User.find_by(provider: "facebook", uid:  payload["id"])
		
		return user if user 


		if payload["email"].present?
			
			user = User.find_by(email: payload["email"])
			if user
				user.provider = "facebook"
				user.uid = payload["id"]
				user.save!
				return user 
			end 
		end 

		user = User.new(
			email: payload["email"], 
			provider: "facebook", 
			uid: payload["id"], 
			username: payload["name"], 
			password: SecureRandom.hex(16)
		)
		user.save!
		user
	end 


	def unauthorized(message)
		render json: {error: message}, status: :unauthorized
	end

end
