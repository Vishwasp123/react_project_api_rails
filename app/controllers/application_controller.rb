class ApplicationController < ActionController::Base
 # before_action :unauthorized

 def encode_token(payload)
 	 payload[:exp] = 1.hour.from_now.to_i ## (token expire time)
   JWT.encode(payload, 'hellomars1211')
  end

	def decoded_token
		
		header = request.headers['token']
		if header
			token = header
			begin
				decoded_token = JWT.decode(token, 'hellomars1211', true, algorithm: 'HS256')			
			 	if BlacklistedToken.exists?(token: token)
				nil
			else
				decoded_token	
			end
			rescue  JWT::ExpiredSignature
				nil
			rescue 	JWT::DecodeError
				nil
			end
		end
	end

	def current_user
		
    token = decoded_token
    if token
      user_id = token[0]['user_id']
      @user = User.find_by(id: user_id)
      @user
    end
  end
  
	def authorized 
		
		unless !!current_user
			render json: {message: 'Please log in'}, status: :unauthorized
		end
	end
end
