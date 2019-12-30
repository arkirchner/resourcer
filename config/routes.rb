Rails.application.routes.draw do
  resources :projects, only: %i[new create show] do
    resources :issues, only: %i[new create show], shallow: true
  end

  root to: "dashboards#show"
end
