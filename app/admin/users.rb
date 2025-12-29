ActiveAdmin.register User do
  
  permit_params :email, :password, :password_confirmation, :username, :phone_number

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :phone_number
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :username
  filter :phone_number
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :username
      f.input :phone_number

      # Password sirf new / update jab chahiye tab
      f.input :password, required: false
      f.input :password_confirmation, required: false
    end
    f.actions
  end

  controller do
    def update
      # agar password blank hai to update me ignore karo
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end
