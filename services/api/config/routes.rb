Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  scope "/api/v1", defaults: { format: :json } do
    devise_for :users,
      path: "auth",
      path_names: { sign_in: "login", sign_out: "logout" },
      controllers: { sessions: "api/v1/sessions" },
      skip: [:registrations, :passwords]
  end

  namespace :api do
    namespace :v1 do
      get "auth/me", to: "auth#me"

      patch "users/me", to: "users#me_update"
      patch "users/me/password", to: "users#me_password"
      patch "users/me/ssh_key", to: "users#me_ssh_key"
      get "users/:id/otp_qr", to: "users#otp_qr"
      resources :users, only: [:index, :create, :update]

      resources :server_groups
      resources :servers, only: [:index, :create, :update, :destroy]
      get "admin/servers", to: "servers#admin_index"

      resources :group_memberships, only: [:index, :create, :destroy]
    end
  end
end
