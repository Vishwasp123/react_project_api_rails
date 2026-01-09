ActiveAdmin.register User do

  permit_params :email, :password, :password_confirmation,
                :username, :phone_number, :country_code

  index do
    selectable_column
    id_column
    column :email
    column :username
    column :phone_number
    column :country_code
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :username
  filter :phone_number
  filter :created_at

  # ---------------- FORM ----------------
  form do |f|
    f.semantic_errors

    f.inputs "User Details" do
      f.input :email
      f.input :username

      f.input :phone_number

      # ✅ Country code dropdown (simple inline CSS)
      f.input :country_code,
              as: :select,
              collection: country_code_list,
              include_blank: "Select Country Code",
              input_html: {
                style: "width:300px; background:#f9f9f9; border:1px solid #d0d0d0; border-radius:6px; padding:8px;"
              }

      f.input :password, required: false
      f.input :password_confirmation, required: false
    end

    f.actions
  end

  # ---------------- CONTROLLER ----------------
  controller do
    helper_method :country_code_list

    def country_code_list
      ISO3166::Country.all.map do |country|
        next unless country.country_code

        label = "#{country.emoji_flag} #{country.translations['en']} (+#{country.country_code})"
        value = "+#{country.country_code}"
        [label, value]
      end.compact.sort_by { |label, _| label }
    end

    def update
      # password blank ho to ignore karo
      if params[:user][:password].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end

end
