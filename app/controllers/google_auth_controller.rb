class GoogleAuthController < ApplicationController
  skip_before_action :verify_authenticity_token

  def google_login
    payload = fetch_google_payload(params[:id_token])
    return unauthorized("Invalid Google token") if payload["error"]

    unless valid_audience?(payload)
      return unauthorized("Invalid Google client")
    end

    unless payload["email_verified"] == "true"
      return unauthorized("Email not verified")
    end

    user = find_or_create_google_user(payload)

    token = JWT.encode(
      { user_id: user.id, exp: 24.hours.from_now.to_i },
      Rails.application.secret_key_base,
      "HS256"
    )

    render json: {
    	message: "Google login successfully", 
    	token: token, 
    	user: {
    		id: user.id, 
    		email: user.email, 
    		provider: user.provider, 
    		uid: user.uid
    	},
    	user_details: UserSerializer.new(user),
    	google_response: payload
    },status: :ok
  end

  private

  def fetch_google_payload(id_token)
    uri = URI("https://oauth2.googleapis.com/tokeninfo?id_token=#{id_token}")
    JSON.parse(Net::HTTP.get(uri))
  end

  def valid_audience?(payload)
    payload["aud"] == ENV["GOOGLE_CLIENT_ID"] ||
      payload["azp"] == ENV["GOOGLE_CLIENT_ID"]
  end

  def find_or_create_google_user(payload)
    User.find_by(provider: "google", uid: payload["sub"]) ||
      User.find_by(email: payload["email"])&.tap { |u|
        u.update(provider: "google", uid: payload["sub"])
      } ||
      User.create!(
        email: payload["email"],
        provider: "google",
        uid: payload["sub"],
        username: payload["name"],
        password: SecureRandom.hex(16)
      )
  end

  def unauthorized(message)
    render json: { error: message }, status: :unauthorized
  end
end
