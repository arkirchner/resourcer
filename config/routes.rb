Rails.application.routes.draw do
  resources :projects, only: %i[new create show] do
    resources :project_members, only: :index
    resources :issues,
              only: %i[new create show index edit update], shallow: true
    resource :project_gantt_chart, only: :show
  end
  resources :markdown_previews, only: :create

  resource :dashboard, only: :show

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/auth", to: "sessions#destroy"

  root to: "landing_pages#show"
end
