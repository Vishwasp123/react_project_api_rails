require 'rails_helper'

RSpec.describe "User", type: :request do

	before do 
		@admin_user = AdminUser.create!(
			email: "admin@example.com", 
			password: "password", 
			password_confirmation: "password"
		)
		sign_in @admin_user

		@user = User.create(username: "sdfsdf", phone_number: "+917418527418", email: "abc@email.com", password: "123456")
	end
	#---------------INDEX--------------
	describe "GET /admin/user" do 
		it "render index page" do  
			get admin_users_path
			expect(response).to have_http_status(:ok)
		end 
	end 


	#------------New--------------

	describe "Post /admin/user/new" do 
		it "render create page" do 
		 
			get  new_admin_user_path
			
			expect(response).to have_http_status(:ok)
		end 
	end 

	# -----------CREATE------------
	describe "Post /admin/users" do 
	
		it "create new user" do  
		  post admin_users_path, params: {
		    user: {
		      email: "new_admin@example.com",
		      password: "password",
		      password_confirmation: "password",
		      username: "new_user",
		      phone_number: "+918527419638"
		    }
		  }

		  expect(response).to have_http_status(:found)
		end
	end  

	#-----------------Edit------------

	describe "GET  /admin/users/:id/edit" do 
		it "render edit page" do  
			get edit_admin_user_path(@user)
			expect(response).to have_http_status(:ok)
		end 
	end 

	#----------------UPDATE--------
	describe "PUT  /admin/users/:id" do 
		it "update  user email" do  
			put  admin_admin_user_path(@user), params: {
				admin_user: {
					email: "update_user@example.com"
				}
			}
			expect(response).to have_http_status(:found)
		end 
	end

	#------------------DELETE------------

	describe "DELETE  /admin/users/:id" do 
		it "DELETE admin user " do  

			user_to_delete = User.create!(
	        email: "delete_me@example.com",
	        password: "password",
	        password_confirmation: "password",
	        username: "adminuser", 
	        phone_number: "+91 7418529638"
	      )

			delete admin_user_path(user_to_delete)
		
			expect(response).to have_http_status(:found)
		end 
	end
end 