# frozen_string_literal: true

Rails.application.routes.draw do
  # root 'welcome#index'
  get 'pages/page_search'

  get 'intel/intel_privacy'
  get 'intel/intel_build_notes'
  get 'intel/intel_introduction'

  get 'settings/settings_how_it_works'
  get 'settings/settings_layout_options'
  get 'settings/settings_saving_db'
  get 'settings/settings_skin_options'

  get 'info/info_app_licensing'
  get 'info/info_app_flavors'
  get 'info/info_app_docs'

  get 'ui/ui_alerts'
  get 'ui/ui_accordion'
  get 'ui/ui_badges'
  get 'ui/ui_breadcrumbs'
  get 'ui/ui_buttons'
  get 'ui/ui_button_group'
  get 'ui/ui_cards'
  get 'ui/ui_carousel'
  get 'ui/ui_collapse'
  get 'ui/ui_dropdowns'
  get 'ui/ui_list_filter'
  get 'ui/ui_modal'
  get 'ui/ui_navbars'
  get 'ui/ui_panels'
  get 'ui/ui_pagination'
  get 'ui/ui_popovers'
  get 'ui/ui_progress_bars'
  get 'ui/ui_scrollspy'
  get 'ui/ui_side_panel'
  get 'ui/ui_spinners'
  get 'ui/ui_tabs_pills'
  get 'ui/ui_toasts'
  get 'ui/ui_tooltips'

  get 'utilities/utilities_borders'
  get 'utilities/utilities_clearfix'
  get 'utilities/utilities_color_pallet'
  get 'utilities/utilities_display_property'
  get 'utilities/utilities_fonts'
  get 'utilities/utilities_flexbox'
  get 'utilities/utilities_helpers'
  get 'utilities/utilities_position'
  get 'utilities/utilities_responsive_grid'
  get 'utilities/utilities_sizing'
  get 'utilities/utilities_spacing'
  get 'utilities/utilities_typography'

  get 'icons/icons_fontawesome_light'
  get 'icons/icons_fontawesome_regular'
  get 'icons/icons_fontawesome_solid'
  get 'icons/icons_fontawesome_brand'

  get 'icons/icons_nextgen_general'
  get 'icons/icons_nextgen_base'

  get 'icons/icons_stack_showcase'
  get 'icons/icons_stack_generate'

  get 'tables/tables_basic'
  get 'tables/tables_generate_style'

  get 'form/form_basic_inputs'
  get 'form/form_checkbox_radio'
  get 'form/form_input_groups'
  get 'form/form_validation'

  get 'plugins/plugin_faq'
  get 'plugins/plugin_waves'
  get 'plugins/plugin_pacejs'
  get 'plugins/plugin_smartpanels'
  get 'plugins/plugin_bootbox'
  get 'plugins/plugin_slimscroll'
  get 'plugins/plugin_throttle'
  get 'plugins/plugin_navigation'
  get 'plugins/plugin_i18next'
  get 'plugins/plugin_appcore'

  get 'pages/page_chat'
  get 'pages/page_contacts'
  get 'pages/page_forum_list'
  get 'pages/page_forum_threads'
  get 'pages/page_forum_discussion'
  get 'pages/page_inbox_general'
  get 'pages/page_inbox_read'
  get 'pages/page_inbox_write'
  get 'pages/page_invoice'

  get 'pages/page_forget'
  get 'pages/page_locked'
  get 'pages/page_login'
  get 'pages/page_login_alt'
  get 'pages/page_register'
  get 'pages/page_confirmation'

  get 'pages/page_error'
  get 'pages/page_error_404'
  get 'pages/page_error_announced'
  get 'pages/page_profile'

  resources :story_subcategories
  resources :story_categories
  resources :yh_photo_fr_ynas do
    member do
      get 'taken'
    end
  end
  resources :yh_photo_trs do
    member do
      get 'taken'
    end
  end
  resources :yh_prs do
    member do
      get 'taken'
    end
  end
  resources :line_fragments
  resources :paragraphs
  resources :expert_writers
  resources :exepert_writers
  resources :reporter_graphics do
    member do
      get 'download'
    end
    collection do
      get 'my'
    end
  end
  resources :yh_graphics do
    member do
      get 'taken'
    end
  end
  resources :yh_pictures do
    member do
      get 'taken'
    end
  end
  resources :yh_articles do
    member do
      get 'taken'
    end
  end
  resources :combo_ads
  resources :reporter_images do
    member do
      get 'download'
    end
    collection do
      get 'my'
    end
  end
  resources :ad_bookings
  resources :categories
  resources :ad_plans
  resources :graphics
  resources :announcements
  resources :stories do
    member do
      get 'assign_position'
      get 'un_assign_position'
      get 'backup'
      get 'recover_backup'
    end
    collection do
      get 'my'
    end
  end
  resources :spreads
  # api
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[index create show update destroy]
      resources :microposts, only: %i[index create show update destroy]
    end
  end

  resources :profiles
  resources :holidays
  resources :reporters
  resources :article_plans
  resources :reporter_groups
  resources :opinion_writers
  resources :heading_bg_images
  resources :stroke_styles do
    collection do
      get 'style_view'
      get 'style_update'
    end
    member do
      get 'download_pdf'
      get 'save_current'
    end
  end
  resources :graphic_requests do
    collection do
      get 'my'
    end
  end
  resources :section_headings
  resources :heading_ad_images do
    member do
      get 'today'
    end
  end
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

  devise_scope :user do
    authenticated :user do
      # root to: 'home#welcome'
      root to: 'welcome#index'
    end
    unauthenticated :user do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :users do
    member do
      get 'my_story'
    end
    collection do
      get 'reporter_profile'
    end
  end

  resources :ad_boxes do
    member do
      patch 'upload_ad_image'
      get 'download_pdf'
    end
  end

  resources :ad_images do
    collection do
      # get 'current'
      get 'place_all'
    end
  end

  resources :working_articles do
    member do
      get 'autofit_by_height'
      get 'autofit_by_height_plus'
      get 'autofit_with_sibllings'
      get 'autofit_with_sibllings_plus'
      get 'autofit_by_image_size'
      get 'download_pdf'
      patch 'upload_images'
      patch 'upload_graphics'
      get 'zoom_preview'
      patch 'assign_reporter'
      get 'add_image'
      get 'extend_zero'
      get 'extend_one'
      get 'extend_two'
      get 'extend_three'
      get 'extend_four'
      get 'reduce_one'
      get 'reduce_two'
      get 'reduce_three'
      get 'reduce_four'
      get 'swap'

      get 'show_quote_box'
      get 'show_quote_box_for_opinion2'
      get 'show_quote_box_for_opinion3'
      get 'hide_quote_box'

      get 'boxed_subtitle_one'
      get 'boxed_subtitle_two'
      get 'boxed_subtitle_zero'
      get 'announcement_one'
      get 'announcement_two'
      get 'announcement_zero'
      get 'swap'

      get 'image_1x1'
      get 'image_2x2'
      get 'image_3x3'
      get 'image_4x4'
      get 'image_5x5'
      get 'image_auto'
      get 'change_story'
      patch 'update_story'
      get 'select_reporter_image'
      get 'select_reporter_graphic'
    end
  end

  resources :issues do
    member do
      get 'change_current'
      get 'update_plan'
      get 'current_plan'
      get 'images'
      patch 'upload_images'
      get 'ad_images'
      get 'ad_boxes'
      patch 'upload_ad_images'
      get 'clone_pages'
      get 'slide_show'
      get 'assign_reporter'
      get 'print_status'

      get 'generate_stories'

      get 'first_group'
      get 'second_group'
      get 'third_group'
      get 'fourth_group'
      get 'fifth_group'
      get 'sixth_group'
      get 'seventh_group'
      get 'eighth_group'
      get 'nineth_group'
      get 'ad_group'
      get 'spread'

      get 'first_group_stories'
      get 'second_group_stories'
      get 'third_group_stories'
      get 'fourth_group_stories'
      get 'fifth_group_stories'
      get 'sixth_group_stories'
      get 'seventh_group_stories'
      get 'eighth_group_stories'
      get 'nineth_group_stories'

      get 'save_story_xml'
      get 'download_story_xml'
      get 'save_preview_xml'
      get 'download_preview_xml'
      get 'send_xml_to_ebiz'
      get 'save_mobile_preview_xml'
      get 'send_mobile_preview_xml'
      get 'merge_container_xml'
    end
  end

  resources :pages do
    member do
      get 'save_as_template'
      get 'download_pdf'
      get 'dropbox'
      get 'change_template'
      get 'regenerate_pdf'
      get 'save_current_as_default'
      get 'clone'
      get 'send_proof_reading_pdf'
      get 'send_pdf_to_printer'
      get 'assign_stories'
    end
  end

  resources :page_headings do
    member do
      get 'download_pdf'
      get 'download_heading_pdf'
      patch 'upload_images'
    end
  end
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
      get 'save'
    end
    member do
      get 'download_pdf'
      get 'duplicate'
      get 'regenerate_pdf'
    end
  end

  resources :images do
    member do
      get 'crop'
      patch 'save_crop'
    end
    collection do
      get 'current'
      get 'place_all'
    end
  end

  # match 'hello' => Api::NewsLayout, :via => :get
  # match 'new_issue/:date' => Api::NewsLayout, :via => :get
  # match 'api/v1/issue_plan' => Api::NewsLayout, :via => :get
  # match 'api/v1/page/:date/:page_number' => Api::NewsLayout, :via => :get
  # match 'api/v1/working_article/:date/:page/:order' => Api::NewsLayout, :via => :post

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
      get 'save_current'
    end
    member do
      get 'download_pdf'
      get 'duplicate'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # root 'home#welcome'
end
