Rails.application.routes.draw do
  resources :issues, only: %i[new create show]

  root to: "dashboards#show"
end
