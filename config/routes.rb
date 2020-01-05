Rails.application.routes.draw do
  resources :projects, only: %i[new create show] do
    resources :issues, only: %i[new create show index edit update], shallow: true
    resource :project_gantt_chart, only: :show
  end

  root to: "dashboards#show"
end
