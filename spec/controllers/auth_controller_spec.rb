require 'rails_helper'

RSpec.describe AuthController, type: :controller do

	before do 
		@user = User.create(username: "sdfsf", phone_number: "+918527419638", email: "example@gmail.com", password: "123456")
		@jwt_token = JWT.encode(
      { user_id: @user.id },
      Rails.application.secret_key_base
    )
	end 

	describe "GET #LOGIN" do 
		context "it is valid params" do 
			it "login user" do  
				post :login, params: {
					user: {
						email: "example@gmail.com",  
						password: "123456"
					}	
				}

				json = JSON.parse(response.body)

				expect(response.status).to eq(200)
				expect(response.message).to eq("OK")
			end 
		end

		context "it is invalid params" do 
			it "login user invalid params" do 
				post :login, params: {
					user: {
						email: "example1@gmail.com", 
						password: "123456"
					}
				}
				json = JSON.parse(response.body)
				expect(response).to have_http_status(401)
				expect(response).to have_http_status(:unauthorized)
			end  
		end 
	end 

	describe "delete #logout" do 
		context "when Autozation header is present" do 
			it "logs out user and blacklist token" do  

				request.headers['token'] = "#{@jwt_token}"
				 delete :logout, params: {toke: @jwt_token}
    
        json = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(json["message"]).to eq("Logged out successfully")
    
			end

			it "when token is not valid" do 
				delete :logout, params: { token: "token"}
				json = JSON.parse(response.body)
				expect(response).to have_http_status(401)
				expect(json["error"]).to eq("Token not provided")
			end 
		end 
	end 
end 
