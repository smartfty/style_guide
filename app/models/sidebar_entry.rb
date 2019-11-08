class SidebarEntry
  class << self
    include Rails.application.routes.url_helpers
  end

  def self.all
    [
      {
        group_title: '나의 뉴스',
        children: [
          {
            href: my_stories_path,
            title: '나의 기사',
            icon: 'fa-pencil-alt',
          },
          {
            href: my_reporter_images_path,
            title: '나의 사진',
            icon: 'fa-camera-alt',
          },
          {
            href: '#',
            title: '나의 그래픽',
            icon: 'fa-chart-bar',
            children: [
              {
                href: my_reporter_graphics_path,
                title: '그래픽 확인',
              },
              {
                href: my_graphic_requests_path,
                title: '그래픽 의뢰',
              },
            ]
          },
          {
            href: '#',
            title: '나의 비디오',
            icon: 'fa-video',
          },
          {
            href: '#',
            title: '나의 오디오',
            icon: 'fa-bullhorn',
          },
        ]
      },
      {
        group_title: '연합 뉴스',
        children: [
          {
            href: yh_articles_path,
            title: '연합 국내취재 기사',
            icon: 'fa-file-edit',
          },
          {
            href: yh_pictures_path,
            title: '연합 국내취재 사진',
            icon: 'fa-file-image',
          },
          {
            href: yh_photo_trs_path,
            title: '연합 번역 외신 사진',
            icon: 'fa-file-check',
          },
          {
            href: yh_photo_fr_ynas_path,
            title: '연합 외신 사진',
            icon: 'fa-file-powerpoint',
          },
          {
            href: yh_graphics_path,
            title: '연합 그래픽',
            icon: 'fa-file-archive',
          },
          {
            href: yh_prs_path,
            title: '연합 PR보도자료',
            icon: 'fa-file-audio',
          },
        ]
      },
      {
        group_title: '뉴스 데스크',
        children: [
          {
            href: '#',
            title: '지면 데스크',
            icon: 'fa-sitemap',
          },
          {
            href: '#',
            title: '온라인 데스크',
            icon: 'fa-laptop',
            children: [
              {
                href: '#',
                title: '지면 데스크',
              },
              {
                href: '#',
                title: '온라인 데스크',
              },
            ]
          },
        ]
      },
      {
        group_title: '뉴스고 지면편집',
        children: [
          {
            href: new_issue_path,
            title: '새로운 호 생성',
            icon: 'fa-sitemap',
          },
          {
            href: issue_path(Issue.last),
            title: Issue.last.korean_date_string,
            icon: 'fa-sitemap',
            children: [
              {
                href: current_plan_issue_path(Issue.last),
                title: '면 배열표',
              },
              {
                href: print_status_issue_path(Issue.last),
                title: '교정/인쇄현황',
              },
              {
                href: issue_path(Issue.last),
                title: '전체 보기',
              },
              {
                href: first_group_issue_path(Issue.last),
                title: '<1면> 편집',
              },
              {
                href: fifth_group_issue_path(Issue.last),
                title: '<금융> 편집',
              },
              {
                href: nineth_group_issue_path(Issue.last),
                title: '<오피니언> 편집',
              },
              {
                href: ad_group_issue_path(Issue.last),
                title: '<전면 광고> 편집',
              },
            ]
          },
          {
            href: '#',
            title: '',
            icon: 'fa-laptop',
          },
        ]
      },
      {
        group_title: 'CMS 설정',
        children: [
          {
            href: '#',
            title: '사용자 및 부서 관리',
            icon: 'fa-cog',
          },
          {
            href: '#',
            title: '기사 분류 관리',
            icon: 'fa-cog',
          },
          {
            href: '#',
            title: '개인 환경 설정',
            icon: 'fa-cog',
            children: [
              {
                href: info_info_app_licensing_path,
                title: '사용자 및 부서 관리',
              },
            ]
          },
        ]
      },
      {
        group_title: 'SmartAdmin test',
        children: [
          {
            href: '#',
            title: 'Application Intel',
            icon: 'fa-info-circle',
            children: [
              {
                href: intel_intel_introduction_path,
                title: 'Introduction',
              },
              {
                href: intel_intel_privacy_path,
                title: 'Privacy',
              },
              {
                href: intel_intel_build_notes_path,
                title: 'Build Notes',
                subtitle: "v#{Rails.configuration.version}",
              },
            ]
          },
          {
            href: '#',
            title: 'Theme Settings',
            icon: 'fa-cog',
            children: [
              {
                href: settings_settings_how_it_works_path,
                title: 'How it works',
              },
              {
                href: settings_settings_layout_options_path,
                title: 'Layout Options',
              },
              {
                href: settings_settings_skin_options_path,
                title: 'Skin Options',
              },
              {
                href: settings_settings_saving_db_path,
                title: 'Saving to Database',
              },
            ]
          },
          {
            href: '#',
            title: 'Package Info',
            icon: 'fa-tag',
            children: [
              {
                href: info_info_app_licensing_path,
                title: 'Product Licensing',
              },
              {
                href: info_info_app_flavors_path,
                title: 'Different Flavors',
              },
            ]
          },
        ]
      },
      {
        group_title: 'Tools & Components',
        children: [
          {
            href: '#',
            title: 'UI Components',
            icon: 'fa-window',
            children: [
              {
                href: ui_ui_alerts_path,
                title: 'Alerts',
              },
              {
                href: ui_ui_accordion_path,
                title: 'Accordions',
              },
              {
                href: ui_ui_badges_path,
                title: 'Badges',
              },
              {
                href: ui_ui_breadcrumbs_path,
                title: 'Breadcrumbs',
              },
              {
                href: ui_ui_buttons_path,
                title: 'Buttons',
              },
              {
                href: ui_ui_button_group_path,
                title: 'Button Group',
              },
              {
                href: ui_ui_cards_path,
                title: 'Cards',
              },
              {
                href: ui_ui_carousel_path,
                title: 'Carousel',
              },
              {
                href: ui_ui_collapse_path,
                title: 'Collapse',
              },
              {
                href: ui_ui_dropdowns_path,
                title: 'Dropdowns',
              },
              {
                href: ui_ui_list_filter_path,
                title: 'List Filter',
              },
              {
                href: ui_ui_modal_path,
                title: 'Modal',
              },
              {
                href: ui_ui_navbars_path,
                title: 'Navbars',
              },
              {
                href: ui_ui_panels_path,
                title: 'Panels',
              },
              {
                href: ui_ui_pagination_path,
                title: 'Pagination',
              },
              {
                href: ui_ui_popovers_path,
                title: 'Popovers',
              },
              {
                href: ui_ui_progress_bars_path,
                title: 'Progress Bars',
              },
              {
                href: ui_ui_scrollspy_path,
                title: 'ScrollSpy',
              },
              {
                href: ui_ui_side_panel_path,
                title: 'Side Panel',
              },
              {
                href: ui_ui_spinners_path,
                title: 'Spinners',
              },
              {
                href: ui_ui_tabs_pills_path,
                title: 'Tabs & Pills',
              },
              {
                href: ui_ui_toasts_path,
                title: 'Toasts',
              },
              {
                href: ui_ui_tooltips_path,
                title: 'Tooltips',
              },
            ]
          },
          {
            href: '#',
            title: 'Utilities',
            icon: 'fa-bolt',
            children: [
              {
                href: utilities_utilities_borders_path,
                title: 'Borders',
              },
              {
                href: utilities_utilities_clearfix_path,
                title: 'Clearfix',
              },
              {
                href: utilities_utilities_color_pallet_path,
                title: 'Color Pallet',
              },
              {
                href: utilities_utilities_display_property_path,
                title: 'Display Property',
              },
              {
                href: utilities_utilities_fonts_path,
                title: 'Fonts',
              },
              {
                href: utilities_utilities_flexbox_path,
                title: 'Flexbox',
              },
              {
                href: utilities_utilities_helpers_path,
                title: 'Helpers',
              },
              {
                href: utilities_utilities_position_path,
                title: 'Position',
              },
              {
                href: utilities_utilities_responsive_grid_path,
                title: 'Responsive Grid',
              },
              {
                href: utilities_utilities_sizing_path,
                title: 'Sizing',
              },
              {
                href: utilities_utilities_spacing_path,
                title: 'Spacing',
              },
              {
                href: utilities_utilities_typography_path,
                title: 'Typography',
              },
              {
                href: 'javascript:void(0);',
                title: 'Menu child',
                children: [
                  {
                    href: 'javascript:void(0);',
                    title: 'Sublevel Item',
                  },
                  {
                    href: 'javascript:void(0);',
                    title: 'Another Item',
                  },
                ]
              },
              {
                href: 'javascript:void(0);',
                title: 'Disabled item',
                disabled: true
              },
            ]
          },
          {
            href: '#',
            title: 'Font Icons',
            subtitle: '2,500+',
            subtitle_class: 'dl-ref bg-primary-500 hidden-nav-function-minify hidden-nav-function-top',
            icon: 'fa-map-marker-alt',
            children: [
              {
                href: 'javascript:void(0);',
                title: 'FontAwesome Pro',
                children: [
                  {
                    href: icons_icons_fontawesome_light_path,
                    title: 'Light',
                  },
                  {
                    href: icons_icons_fontawesome_regular_path,
                    title: 'Regular',
                  },
                  {
                    href: icons_icons_fontawesome_solid_path,
                    title: 'Solid',
                  },
                  {
                    href: icons_icons_fontawesome_brand_path,
                    title: 'Brand',
                  },
                ]
              },
              {
                href: 'javascript:void(0);',
                title: 'NextGen Icons',
                children: [
                  {
                    href: icons_icons_nextgen_general_path,
                    title: 'General',
                  },
                  {
                    href: icons_icons_nextgen_base_path,
                    title: 'Base',
                  },
                ]
              },
              {
                href: 'javascript:void(0);',
                title: 'Stack Icons',
                children: [
                  {
                    href: icons_icons_stack_showcase_path,
                    title: 'Showcase',
                  },
                  {
                    href: icons_icons_stack_generate_path,
                    title: 'Generate Stack',
                  },
                ]
              },
            ]
          },
          {
            href: '#',
            title: 'Tables',
            icon: 'fa-th-list',
            children: [
              {
                href: tables_tables_basic_path,
                title: 'Basic Tables',
              },
              {
                href: tables_tables_generate_style_path,
                title: 'Generate Table Style',
              },
            ]
          },
          {
            href: '#',
            title: 'Form Stuff',
            icon: 'fa-edit',
            children: [
              {
                href: form_form_basic_inputs_path,
                title: 'Basic Inputs',
              },
              {
                href: form_form_checkbox_radio_path,
                title: 'Checkbox & Radio',
              },
              {
                href: form_form_input_groups_path,
                title: 'Input Groups',
              },
              {
                href: form_form_validation_path,
                title: 'Validation',
              },
            ]
          },
        ]
      },
      {
        group_title: 'Plugins & Addons',
        children: [
          {
            href: '#',
            title: 'Core Plugins',
            icon: 'fa-shield-alt',
            children: [
              {
                href: plugins_plugin_faq_path,
                title: 'Plugins FAQ',
              },
              {
                href: plugins_plugin_waves_path,
                title: 'Waves',
                subtitle: '9 KB',
                subtitle_class: 'dl-ref label bg-primary-400 ml-2',
              },
              {
                href: plugins_plugin_pacejs_path,
                title: 'PaceJS',
                subtitle: '13 KB',
                subtitle_class: 'dl-ref label bg-primary-500 ml-2',
              },
              {
                href: plugins_plugin_smartpanels_path,
                title: 'SmartPanels',
                subtitle: '9 KB',
                subtitle_class: 'dl-ref label bg-primary-600 ml-2',
              },
              {
                href: plugins_plugin_bootbox_path,
                title: 'BootBox',
                subtitle: '15 KB',
                subtitle_class: 'dl-ref label bg-primary-600 ml-2',
              },
              {
                href: plugins_plugin_slimscroll_path,
                title: 'Slimscroll',
                subtitle: '5 KB',
                subtitle_class: 'dl-ref label bg-primary-700 ml-2',
              },
              {
                href: plugins_plugin_throttle_path,
                title: 'Throttle',
                subtitle: '1 KB',
                subtitle_class: 'dl-ref label bg-primary-700 ml-2',
              },
              {
                href: plugins_plugin_navigation_path,
                title: 'Navigation',
                subtitle: '2 KB',
                subtitle_class: 'dl-ref label bg-primary-700 ml-2',
              },
              {
                href: plugins_plugin_i18next_path,
                title: 'i18next',
                subtitle: '10 KB',
                subtitle_class: 'dl-ref label bg-primary-700 ml-2',
              },
              {
                href: plugins_plugin_appcore_path,
                title: 'App.Core',
                subtitle: '14 KB',
                subtitle_class: 'dl-ref label bg-success-700 ml-2',
              },
            ]
          },
        ]
      },
      {
        group_title: 'Layouts & Apps',
        children: [
          {
            href: '#',
            title: 'Page Views',
            icon: 'fa-plus-circle',
            children: [
              {
                href: pages_page_chat_path,
                title: 'Chat',
              },
              {
                href: pages_page_contacts_path,
                title: 'Contacts',
              },
              {
                href: 'javascript:void(0);',
                title: 'Forum',
                children: [
                  {
                    href: pages_page_forum_list_path,
                    title: 'List',
                  },
                  {
                    href: pages_page_forum_threads_path,
                    title: 'Threads',
                  },
                  {
                    href: pages_page_forum_discussion_path,
                    title: 'Discussion',
                  },
                ]
              },
              {
                href: 'javascript:void(0);',
                title: 'Inbox',
                children: [
                  {
                    href: pages_page_inbox_general_path,
                    title: 'General',
                  },
                  {
                    href: pages_page_inbox_read_path,
                    title: 'Read',
                  },
                  {
                    href: pages_page_inbox_write_path,
                    title: 'Write',
                  },
                ]
              },
              {
                href: pages_page_invoice_path,
                title: 'Invoice (printable)',
              },
              {
                href: 'javascript:void(0);',
                title: 'Authentication',
                children: [
                  {
                    href: pages_page_forget_path,
                    title: 'Forget Password',
                  },
                  {
                    href: pages_page_locked_path,
                    title: 'Locked Screen',
                  },
                  {
                    href: pages_page_login_path,
                    title: 'Login',
                  },
                  {
                    href: pages_page_login_alt_path,
                    title: 'Login Alt',
                  },
                  {
                    href: pages_page_register_path,
                    title: 'Register',
                  },
                  {
                    href: pages_page_confirmation_path,
                    title: 'Confirmation',
                  },
                ]
              },
              {
                href: 'javascript:void(0);',
                title: 'Error Pages',
                children: [
                  {
                    href: pages_page_error_path,
                    title: 'General Error',
                  },
                  {
                    href: pages_page_error_404_path,
                    title: 'Server Error',
                  },
                  {
                    href: pages_page_error_announced_path,
                    title: 'Announced Error',
                  },
                ]
              },
              {
                href: pages_page_profile_path,
                title: 'Profile',
              },
              {
                href: pages_page_search_path,
                title: 'Search Results',
              },
            ]
          },
        ]
      },
    ]
  end
end