Rails.application.routes.draw do
  resources :placed_ads
  resources :working_articles do
    member do
      get 'download_pdf'
    end
  end
  resources :issues
  resources :pages do
    member do
      get 'download_pdf'
    end
  end

  resources :page_headings
  resources :image_templates do
    collection do
      get 'six'
      get 'seven'
    end

    member do
      get 'download_pdf'
      get 'duplicate'
    end
  end

  resources :ads
  resources :sections do
    collection do
      get 'five'
      get 'six'
      get 'seven'
    end
    member do
      get 'download_pdf'
      get 'duplicate'
    end
  end

  resources :images do
    collection do
      get 'current'
    end
  end

  get 'home/welcome'

  get 'home/help'

  resources :articles do
    collection do
      get 'one'
      get 'two'
      get 'three'
      get 'four'
      get 'five'
      get 'six'
      get 'seven'
    end
    member do
      get 'download_pdf'
      get 'fill'
      get 'add_image'
      get 'select_image'
      get 'add_personal_image'
      get 'add_quote'
    end
  end

  resources :publications
  resources :text_styles do
    collection do
      get 'style_view'
      get 'style_update'
    end
    member do
      get 'download_pdf'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#welcome'

end
