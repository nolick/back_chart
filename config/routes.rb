Rails.application.routes.draw do
  get 'pages/index'
  get 'backlog_api/milestones'
  get 'backlog_api/issues'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
