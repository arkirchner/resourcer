Rails.application.routes.draw do
  resources :projects, only: %i[new create show] do
    resources :members, controller: :project_members, only: :index
    resources :issues,
              only: %i[new create show index edit update]
    resource :project_gantt_chart, only: :show
    resources :invitations, only: %i[new show create show]
  end
  resources :markdown_previews, only: :create
  resources :join_projects, only: :show

  resource :dashboard, only: :show

  if Rails.env.development?
    match "/auth/:provider/callback", to: "sessions#create", via: %i[get post]
  else
    get "/auth/:provider/callback", to: "sessions#create"
  end

  get "/auth/failure", to: "sessions#failure"
  delete "/auth", to: "sessions#destroy"

  root to: "landing_pages#show"
end
