
require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before do 
    
    @user = User.create(username: "sdfsdf", phone_number: "+917418527418", email: "abc@email.com", password: "123456")

    @jwt_token = JWT.encode(
    { user_id: @user.id },
    'hellomars1211',
    'HS256'
     )
  end 
  

  describe "GET /index" do
    it "return all users" do 
      get :index
      expect(response).to have_http_status(:ok)
    end 
  end

  describe "Post /create user" do 
   context 'invalid create user return errors' do
    #invalid params username and phone number not presnt 
      let(:invalid_params) do
       {
        user: {
          email: "test@gmail.com", 
          password: "password"
        }
      }
      end 

      #invalid phone number 
      let(:invalid_phone_number) do
       {
        user: {
          email: "test@gmail.com", 
          password: "password",
          username: "xyx",
          phone_number: "+9112345678"
        }
      }
      end 

      let(:valid_params) do 
        {
          user: {

            email: "test@gmail.com", 
            password: "",
          }
        }
      end

      context "when params is invalid " do 
        it "username and phone number not present" do 
          post :create, params: invalid_params
          json = JSON.parse(response.body)
          expect(json["errors"]["username"][0]).to eq("can't be blank")
          expect(json["errors"]["phone_number"][0]).to eq("can't be blank")
        end 
      end 

      context "when phone_number params invalid" do 
        it "phone nuber are not valid" do 
          post :create, params:  invalid_phone_number
          json = JSON.parse(response.body)
          expect(json["errors"]["phone_number"][0]).to eq("is not valid phone_number")
        end 
      end 
   end 
   context "crate user and return token and sucessfull response" do  
     let(:valid_params) do
       {
        user: {
          email: "test@gmail.com", 
          password: "password", 
          username: "dsfsfsd", 
          phone_number: "+91 7418529635"
        }
      }
      end 

     context "crete user /Post" do 
        it "user create and return token" do  
          post :create, params: valid_params
          json = JSON.parse(response.body)
          expect(response.status).to eq(201)
          expect(response.message).to eq("Created")
        end 
     end 
   end 
  end 

  describe"Get #show " do 
    it "returns current user using token'" do  
      get :show, params: {token:  @jwt_token}
      expect(response).to have_http_status(:ok)
    end 
  end

  describe "PATCH #UPDATE" do 
    context "invalid user not update" do 
      it "update user details invalid" do 
        request.headers['Authorization'] = "Bearer #{@jwt_token}" 

        patch :update, params: {
          user: {
            username: "help"
          }
        }
        json = JSON.parse(response.body)

        expect(json["errors"][0]).to eq("User not found")
      end

      it "valid user update details" do  
        request.headers['token'] = @jwt_token 

        patch :update, params: {user: {username: "Vishwas"}, token: @jwt_token}
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("User update suceefully")
      end 
    end 
  end 


  describe "delete #destroy" do 
    context "delete invalie data" do  
      it "invalid_params token user not delete" do  
        request.headers['token'] = "dsfsdf"
        delete :destroy
        json = JSON.parse(response.body)
        expect(response.message).to eq("Unprocessable Content")
        expect(json["errors"][0]).to eq("User not found")
      end
    end 
    context "delete valid_params data" do  
      it "valid_params token user not delete" do  
        request.headers['token'] = @jwt_token 
        delete :destroy
        json = JSON.parse(response.body)
        expect(response.message).to eq("OK")
        expect(json["message"]).to eq("User id #{@user.id} delete suceefully")
      end
    end 
  end 
end
