class UsersController < ApplicationController
  
  # skip_before_action :authorized, only: [:create]
  skip_before_action :verify_authenticity_token
  
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record


	def index
		users = User.all 
		  render json: users,
         each_serializer: UserSerializer,
         status: :ok
	end 


  def create  
    user = User.new(user_params)
    if user.save
      @token = encode_token(user_id: user.id)
      render json: {
          user: UserSerializer.new(user), 
          token: @token
      }, status: :created
    else 
      render json: {
       errors: user.errors
      }, status: :unprocessable_entity
    end
  end

  def show 
    render json: current_user, status: :ok
  end

  def update 
  	@user = current_user
  	if @user&.update(user_params)
  		
  		render json:{
  			user: UserSerializer.new(@user),
        message: "User update suceefully"
  		}, status: :ok 
  	else 
  		render json: {
      errors: @user ? @user.errors.full_messages : ["User not found"]
    	}, status: :unprocessable_entity
  	end 
  end 

  def destroy
  	@user = current_user
  	if @user&.delete
  		
  		render json:{
  			user: UserSerializer.new(@user),
  			message: "User id #{@user.id} delete suceefully"
  		}, status: :ok 
  	else 
  		render json: {
      errors: @user ? @user.errors.full_messages : ["User not found"]
    	}, status: :unprocessable_entity
  	end 
  end 

  private

  def user_params
	  params.require(:user).permit(
	    :email,
	    :password,
	    :password_confirmation,
	    :username,
      :country_code,
      :phone_number
	  )
  end

  def handle_invalid_record(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end