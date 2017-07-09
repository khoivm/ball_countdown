Rails.application.routes.draw do
  root to: 'pages#index'

  namespace :gumtree do
    root action: 'index'
    get 'items', action: 'get_items'
    post 'save_watcher', action: 'save_watcher'
    post 'remove_watcher', action: 'remove_watcher'
  end
end
