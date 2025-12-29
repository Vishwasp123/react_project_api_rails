require 'rails_helper'

RSpec.describe "AdminUser", type: :request do

	before do 
		@admin_user = AdminUser.create!(
			email: "admin@example.com", 
			password: "password", 
			password_confirmation: "password"
		)
		sign_in @admin_user
	end

	describe "GET /admin/admin_user" do 
		it "render index page" do  
			get admin_admin_users_path
			expect(response).to have_http_status(:ok)
		end 
	end 

	describe "Post /admin/admin_user/new" do 
		it "render create page" do 
		 
			get  new_admin_admin_user_path
			
			expect(response).to have_http_status(:ok)
		end 
	end 

	# create admin admin 
	describe "Post /admin/admin/users" do 
		it "create new user" do  
			post admin_admin_users_path, params: {
				admin_user: {
					email: "new_admin@example.com",
					password: "password",
					password_confirmation: "password"
				}
			}
			expect(response).to have_http_status(:found)
		end 
	end  

	#-----------------Edit------------

	describe "GET  /admin/admin_users/:id/edit" do 
		it "render edit page" do  
			get edit_admin_admin_user_path(@admin_user)
			expect(response).to have_http_status(:ok)
		end 
	end 

	#----------------UPDATE--------
	describe "PUT  /admin/admin_users/:id" do 
		it "update admin user email" do  
			put  admin_admin_user_path(@admin_user), params: {
				admin_user: {
					email: "update_admin@example.com"
				}
			}
			expect(response).to have_http_status(:found)
		end 
	end

	#------------------DELETE------------

	describe "DELETE  /admin/admin_users/:id" do 
		it "DELETE admin user " do  

			admin_to_delete = AdminUser.create!(
	        email: "delete_me@example.com",
	        password: "password",
	        password_confirmation: "password"
	      )

			delete admin_admin_user_path(admin_to_delete)
		
			expect(response).to have_http_status(:found)
		end 
	end
end 