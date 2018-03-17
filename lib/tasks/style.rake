namespace :style do

  desc "create page_headings for all section"
  task :create_page_headings =>:environment do
    puts "creating page_headings ..."
      section_names = [
        '1면',
        '정치',
        '정치',
        '정치',
        '행정',
        '행정',
        '전면광고',
        '국제통일',
        '전면광고',
        '금융',
        '전면광고',
        '금융',
        '금융',
        '산업',
        '산업',
        '산업',
        '산업',
        '정책',
        '정책',
        '기획',
        '기획',
        '오피니언',
        '오피니언',
        '전면광고'
      ]


    section_names.each_with_index do |section_name, i|
      PageHeading.where(publication_id: 1, page_number: i + 1, section_name: section_name, date: Date.new(2017,5,30)).first_or_create
    end
  end

  desc "copy all artifcle outputs to site locaton"
  task :copy_articles_to_site =>:environment do
    WorkingArticle.all.each do |article|
      article.copy_outputs_to_site
    end
  end

  desc "copy all page outputs to site locaton"
  task :copy_pages_to_site =>:environment do
    Page.all.each do |article|
      article.copy_outputs_to_site
    end
  end


  desc "generating pdf for all articles"
  task :generate_pdf =>:environment do
    puts "generating pdf for all articles"
    Article.all.each do |article|
      article.create_folders
      article.generate_pdf
    end
  end


  desc "generating pdf for all articles"
  task :generate_page_pdf =>:environment do
    puts "generating pdf for all articles"
    Page.all.each do |page|
      page.generate_pdf
    end
  end

  desc "generating pdf for all articles unless it exist"
  task :update_pdf_unless =>:environment do
    puts "generating pdf for all articles unless"
    Article.all.each do |article|
      article.create_folders
      article.update_pdf_unless
    end
  end

  desc "update pdf for all articles"
  task :update_pdf =>:environment do
    puts "update pdf for all articles"
    Article.all.each do |article|
      article.update_pdf
    end
  end

  desc "save all articles"
  task :save_article =>:environment do
    puts "save articles"
    Article.all.each do |article|
      article.save_article
    end
  end

  desc "generating pdf for all ads"
  task :generate_ad_pdf =>:environment do
    puts "generating pdf for all ads"
    Ad.all.each do |ad|
      ad.generate_pdf
    end
  end

  desc "update section profile for all sections"
  task :update_section_profile =>:environment do
    puts "update section layout for all sections"
    Section.all.each do |section|
      section.make_profile
      section.save
    end
  end

  desc "update section layout for all sections"
  task :update_section_layout =>:environment do
    puts "update section layout for all sections"
    Section.all.each do |section|
      section.update_section_layout
    end
  end

  desc "generating pdf for all sections"
  task :generate_section_pdf =>:environment do
    puts "generating pdf for all sections"
    Section.all.each do |section|
      section.generate_pdf
    end
  end

  desc "delete generated pdf ad for all section"
  task :delete_pdf_ad =>:environment do
    puts "delete generated pdf ad for all section"
    Section.all.each do |section|
      section.delete_pdf_ad
    end
  end

  desc "generating pdf for all sections"
  task :update_section_layout =>:environment do
    puts "generating pdf for all sections"
    Section.all.each do |section|
      section.update_section_layout
    end
  end

  desc "parse section scv file"
  task :parse_section_csv =>:environment do
    csv_path = "#{Rails.root}/public/1/section/sections.csv"
    csv_text = File.read(csv_path)
    # csv = CSV.parse(csv_text, :headers => true)
    csv = CSV.parse(csv_text)
    keys  = csv.shift
    keys.map!{|e| e.to_sym}
    column_index          = keys.index('column')
    row_index             = keys.index('row')
    page_number_index     = keys.index('page_number')
    section_name_index    = keys.index('section_name')
    layout_index          = keys.index('layout')

    csv.each do |row|
      row_h = Hash[keys.zip row]
      row_h.delete(:profile)
      # Member.create!(row.to_hash)
      Section.where(row_h).first_or_create
    end
  end

  desc "generating heading pdf for all sections "
  task :generate_section_heading_pdf =>:environment do
    puts "generating pdf for all page headings"
    Section.all.each do |section|
      section.generate_heading_pdf
    end
  end

  desc "chnage output to story for all articles"
  task :change_ouput_to_story =>:environment do
    # WorkingArticle.all.each do |wa|
    #   wa.change_ouput_to_story
    # end

    Article.all.each do |a|
      a.change_ouput_to_story
    end
  end

  desc "generating heading pdf for all pages"
  task :generate_page_heading_pdf =>:environment do
    Page.all.each do |page|
      puts "page.page_number:#{page.page_number}"
      page.generate_heading_pdf
    end
  end

  desc "update heading pdf for all pages"
  task  :update_page_heading_pdf=>:environment do
    Page.all.each_with_index do |page, i|
      next if i == 0
      puts "page.page_number:#{page.page_number}"
      PageHeading.generate_pdf(page)
    end
  end

  desc 'create issue plan'
  task :create_issue_plan =>:environment do
    puts "creating a issue"
    issue_content = "issue_plan = [\n"

    24.times do |i|
      page = i+1
      # puts "page:#{page}"
      page_hash = {page_number: page}
      section = Section.where(page_hash).sample
      section_hash = section.attributes
      section_hash = Hash[section_hash.map{ |k, v| [k.to_sym, v] }]
      section_hash[:page_number] = page
      section_hash.delete(:id)
      section_hash.delete(:section_name)
      section_hash.delete(:is_front_page)
      section_hash.delete(:order)
      section_hash.delete(:ad_type) unless section_hash[:ad_type]
      section_hash.delete(:layout)
      section_hash.delete(:publication_id)
      section_hash.delete(:created_at)
      section_hash.delete(:updated_at)
      page_hash.merge!(section_hash)
      issue_content += "  " + page_hash.to_s + ",\n"
    end
    issue_content += "\n]"
    issue_path = "#{Rails.root}/public/1/issue/default_issue_plan.rb"
    File.open(issue_path, 'w'){|f| f.write issue_content}
  end

  desc "show all page's working_articles count"
  task :working_articles_count =>:environment do
    puts "show all page's working_articles count"
    Page.all.each do |page|
      puts "+++++"
      puts "page.page_number:#{page.page_number}"
      puts "page.story_count:#{page.story_count}"
      puts "page.working_articles.length:#{page.working_articles.length}"
    end
  end

  desc "show all working_articles order"
  task :working_articles_order =>:environment do
    puts "show all page's working_articles count"
    WorkingArticle.all.each do |article|
      puts "+++++"
      puts "article.page_id:#{article.page_id}"
      puts "article.order:#{article.order}"
    end
  end

  desc "generate text styles pdf"
  task :generate_text_style_pdf =>:environment do
    puts "generating pdf for all text_styles"
    TextStyle.all.each do |style|
      style.generate_pdf
    end
  end

  desc "update text styles csv"
  task :update_text_styles_csv =>:environment do
    csv_path = "#{Rails.root}/public/1/text_styles/text_styles.csv"
    csv_text = File.read(csv_path)
    # csv = CSV.parse(csv_text, :headers => true)
    csv      = CSV.parse(csv_text)
    keys     = csv.shift
    keys.map!{|e| e.to_sym}
    csv.each do |row|
      row_h = Hash[keys.zip row]
      selecting_h = {}
      selecting_h[:name] = row_h[:name]
      selecting_h[:publication_id] = row_h[:publication_id]
      style = TextStyle.where(selecting_h).first_or_create
      style.update(row_h)
    end
  end

  desc "convert text styles csv"
  task :convert_text_styles_csv =>:environment do
    text_styles_csv_path = "#{Rails.root}/public/1/text_style/text_styles.csv"
    text_styles_list_path = "#{Rails.root}/public/1/text_style/text_styles_list.rb"
    text_styles_named_key_path = "#{Rails.root}/public/1/text_style/text_styles_named_key.rb"
    text_styles_csv_path = "#{Rails.root}/public/1/text_style/text_styles.csv"
    csv_text = File.read(text_styles_csv_path)
    csv      = CSV.parse(csv_text)
    keys     = csv.shift
    keys.map!{|e| e.to_sym}
    text_styles_list = []
    text_styles_named_hash = {}
    csv.each do |row|
      float_row = row.map do |f|
        if f =~/^\d/ || f=~/^-/
          f.to_f
        else
          f
        end
      end
      row_h = Hash[keys.zip float_row]
      text_styles_list << row_h.dup
      name = row_h[:name].to_s
      without_name = row_h.delete(:name)
      text_styles_named_hash[name] = row_h
    end

    File.open(text_styles_list_path, 'w'){|f| f.write text_styles_list.to_s}
    File.open(text_styles_named_key_path, 'w'){|f| f.write text_styles_named_hash.to_s}

  end



end
