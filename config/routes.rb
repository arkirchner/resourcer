Rails.application.routes.draw do
  resources :projects, only: %i[new create show]
  resources :issues, only: %i[new create show]

  root to: "dashboards#show"
end
