Rails.application.routes.draw do
  resources :ad_box_templates
  resources :page_plans do
    member do
      get 'select_template'
      get 'update_page'
    end
  end
  devise_for :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :users

  resources :ad_boxes
  resources :ad_images do
    collection do
      # get 'current'
      get 'place_all'
    end
  end
  resources :working_articles do
    member do
      get 'download_pdf'
    end
  end
  resources :issues do
    member do
      get 'update_plan'
      get 'current_plan'
      get 'images'
      patch 'upload_images'
      get 'ad_images'
      patch 'upload_ad_images'
    end
  end

  resources :pages do
    member do
      get 'download_pdf'
      get 'regenerate_pdf'
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
      get 'regenerate_pdf'
    end
  end

  resources :images do
    collection do
      get 'current'
      get 'place_all'
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

  resources :publications do
    member do
      get 'download_pdf'
    end

  end
  resources :text_styles do
    collection do
      get 'style_view'
      get 'style_update'
    end
    member do
      get 'download_pdf'
      get 'save_current'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#welcome'

end
