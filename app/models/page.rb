# == Schema Information
#
# Table name: pages
#
#  id           :integer          not null, primary key
#  page_number  :integer
#  section_name :string
#  column       :integer
#  row          :integer
#  ad_type      :string
#  story_count  :integer
#  color_page   :boolean
#  profile      :string
#  issue_id     :integer
#  page_plan_id :integer
#  template_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Page < ApplicationRecord
  belongs_to :issue
  belongs_to :page_plan
  has_many :working_articles
  has_many :ad_boxes
  has_one :page_heading
  before_create :copy_attributes_from_template
  after_create :setup


  DAYS_IN_KOREAN = %w{일요일 월요알 화요일 수요일 목요일 금요일 토요일 }
  DAYS_IN_ENGLISH = Date::DAYNAMES

  def path
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}"
  end

  def story_backup_path
    path + "/story_backup"
  end

  def url
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}"
  end

  def pdf_image_path
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.pdf"
  end

  def pdf_path
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.jpg"
  end

  def jpg_path
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/#{page_number}/section.jpg"
  end

  def publication
    issue.publication
  end

  def page_heading_path
    path + "/heading"
  end

  def page_heading_url
    url + "/heading"
  end

  def page_headig_layout_path
    page_heading_path + "/layout.rb"
  end

  def doc_width
    publication.width
  end

  def page_width
    publication.page_width
  end

  def doc_height
    publication.height
  end

  def doc_left_margin
    publication.left_margin
  end

  def doc_top_margin
    publication.top_margin
  end

  def page_height
    publication.page_height
  end

  # def page_heading
  #   publication.page_heading(page_number)
  # end

  def page_heading_width
    publication.page_heading_width
  end

  def page_heading_height
    if page_number == 1
      publication.front_page_heading_height_in_pt
    else
      publication.inner_page_heading_height_in_pt
    end
  end

  def isuue_week_day_in_korean
    date = issue.date
    DAYS_IN_KOREAN[date.wday]
  end

  def year
    date = issue.date
    date.year
  end

  def month
    date = issue.date
    date.month
  end

  def day
    date = issue.date
    date.day
  end

  def korean_date_string
    date = issue.date
    if page_number == 1
      "#{date.year}년 #{date.month}월 #{date.day}일 #{isuue_week_day_in_korean} (#{issue.number}호)"
    else
      "#{date.year}년 #{date.month}월 #{date.day}일 #{isuue_week_day_in_korean}"
    end
  end

  def self.update_page_headings
    Page.all.each do |page|
      PageHeading.generate_pdf(page)
    end
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    copy_section_template
  end

  def sample_ad_folder
    "#{Rails.root}/public/#{publication.id}/ad"
  end

  def issue_ads_folder
    "#{Rails.root}/public/#{publication.id}/issue/#{issue.date.to_s}/ads"
  end

  def ad_image_string
    ad = ad_images.first
    if ad
      return ad_images.first.ad_image_string
    end
    ""
  end

  def save_issue_plan_ad
    if ad_type && ad_type != ""
      issue_ad_string = "#{page_number}_#{ad_type}"
      system "cd #{issue_ads_folder} && touch #{issue_ad_string}"
    end
  end

  def select_sample_ad
    Dir.glob("#{sample_ad_folder}/#{page_columns}#{ad_type}/*{.jpg,.pdf}").sample
  end

  def copy_sample_ad
    if ad_type && ad_type != ""
      sample = select_sample_ad
      basename = File.basename(sample)
      ad_name  = "#{page_number}_#{basename}"
      system "cp #{sample} #{issue_ads_folder}/ad_name"
    end
  end

  def section_template_folder
    "#{Rails.root}/public/#{publication.id}/section/#{page_number}/#{profile}/#{template_id}"
  end

  def update_working_articles
    # delete unused working_articles
    section = Section.find(template_id)
    section.articles.each_with_index do |article, i|
      current = {page_id: self.id, order:i+1}
      if wa = WorkingArticle.where(current).first
        wa.change_article(article)
      else
        current[:article_id] = article.id
        WorkingArticle.create(current)
      end

    end
    # mark unused as inactive
    working_articles.each_with_index do |working_article, i|
      if i >= section.articles.length
        working_article.inactive = true
      else
        working_article.inactive = false
      end
      working_article.save
    end
    # create PageHeading for this page
    heading_atts                  = {}
    heading_atts[:page_number]    = section.page_number
    heading_atts[:page_id]        = self.id
    heading_atts[:date]           = issue.date
    result                        = PageHeading.where(heading_atts).first_or_create


  end

  def update_ad_boxes
    section = Section.find(template_id)
    section.ad_box_templates.each_with_index do |ad_box_template, i|
      current = {page_id: self.id}
      if ad = AdBox.where(current).first
      else
        current[:grid_x] = ad_box_template.grid_x
        current[:grid_y] = ad_box_template.grid_y
        current[:column] = ad_box_template.column
        current[:row] = ad_box_template.row
        AdBox.create(current)
      end
    end

    # mark unused as inactive
    ad_boxes.each_with_index do |ad_box, i|
      if i >= section.ad_box_templates.length
        ad_box.inactive = true
      else
        ad_box.inactive = false
      end
      ad_box.save
    end
  end

  def story_backup_folder
    path + "/story_backup"
  end

  def backup_stories(story_number)
    #code
  end

  def copy_ad_template
    #code
  end

  def copy_config_file
    source = section_template_folder + "/config.yml"
    target = path + "/config.yml"
    system "cp #{source} #{target}"
  end

  def copy_section_template
    source = Dir.glob("#{section_template_folder}/*").first
    old_article_count = working_articles.length
    section           = Section.find(template_id)
    new_aricle_count  = section.story_count
    if source
      copy_config_file
      new_aricle_count.times do |i|
        source = section_template_folder + "/#{i + 1}"
        article_foloder = path + "/#{i + 1}"
        # if artile folder is empty, copy the whole article template folder
        unless File.exist?(article_foloder)
          FileUtils.mkdir_p article_foloder
          system("cp -r #{source}/ #{article_foloder}/")
        # if there are current article, copy layout.rb from article template
        else
          layout_template = source + "/layout.rb"
          system("cp  #{layout_template} #{article_foloder}/")
        end
        puts "i:#{i}"
      end

      # backup or restore story from previous template change
      # if there are some left over article from previous layout, delete them.
      if old_article_count > new_aricle_count
        FileUtils.mkdir_p story_backup_folder unless File.exist?(story_backup_folder)
        left_over_count = old_article_count - new_aricle_count
        puts "left_over_count:#{left_over_count}"
        left_over_count.times do |i|
          story_number      = new_aricle_count + i + 1
          left_over_foloder = path + "/#{story_number}"
          left_over_stroy   = left_over_foloder + "/story.md"
          backup_name       = story_backup_folder + "/#{story_number}_story.md"
          system "rm -r #{left_over_foloder}"
        end
      elsif old_article_count < new_aricle_count
        increased_count = new_aricle_count - old_article_count
        puts "increased_count:#{increased_count}"
        increased_count.times do |i|
          story_number      = old_article_count + i + 1
          increased_foloder = path + "/#{story_number}"
          increased_story   = increased_foloder + "/story.md"
          backup_file_name  = story_backup_folder + "/#{story_number}_story.md"
          system "cp  #{backup_file_name} #{increased_story}" if File.exist?(backup_file_name)
        end
      end

      #TODO How about ad?
      copy_ad_template
    else
      puts "No template in #{section_template_folder}"
    end
    update_working_articles
    update_ad_boxes
  end

  def change_template(new_template_id)
    puts "++++++++ new_template_id:#{new_template_id}"
    new_section                 = Section.find(new_template_id)
    section_hash                = new_section.attributes
    section_hash                = Hash[section_hash.map{ |k, v| [k.to_sym, v] }]
    section_hash[:template_id]  = new_template_id
    section_hash.delete(:id)
    section_hash.delete(:layout)
    section_hash.delete(:order)
    section_hash.delete(:is_front_page)
    section_hash.delete(:publication_id)
    section_hash.delete(:created_at)
    section_hash.delete(:updated_at)
    update(section_hash)
    # update ad_box
    # remove current ad_boxz unless new template has same size ad
    if ad_boxes.count > 0 && (new_section.ad_box_templates.count == 0 || new_section.ad_box_templates.first.ad_type != ad_boxes.first.ad_type)
      ad_boxes.each do |ad_box|
        ad_box.page_id = nil
        ad_box.save
      end
    end
    copy_config_file
    generate_heading_pdf
    update_working_articles
    update_ad_boxes
    regenerate_pdf
  end


  def heading_height_in_pt
    if page_number == 1
      publication.front_page_heading_height_in_pt
    else
      publication.inner_page_heading_height_in_pt
    end
  end

  def page_width
    publication.page_width
  end

  def page_height
    publication.page_height
  end

  def generate_heading_pdf
    page_heading.generate_pdf
  end

  def generate_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."
  end

  def regenerate_pdf
    working_articles.each do |working_article|
      working_article.generate_pdf
    end
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."
  end

  def eval_layout
    eval(layout)
  end

  # other SectionTemplate choices for current page
  def other_choices
    Section.where(page_number: page_number).all
  end

  def page_heading_jpg_path
    page_heading_url + "/output.jpg"
  end

  def page_heading_pdf_path
    page_heading_url + "/output.pdf"
  end

  def page_svg
    "<image xlink:href='#{pdf_image_path}' x='0' y='0' width='#{doc_width}' height='#{doc_height}' />\n"
    #code
  end

  def box_svg
    box_element_svg = page_svg
    box_element_svg += "<g transform='translate(#{doc_left_margin},#{doc_top_margin})' >\n"
    # box_element_svg += page_svg
    box_element_svg += page_heading.box_svg if page_number == 1
    puts "box_element_svg:#{box_element_svg}"
    working_articles.each do |article|
      next if article.inactive
      box_element_svg += article.box_svg
    end
    ad_boxes.each do |ad_box|
      box_element_svg += ad_box.box_svg
    end
    box_element_svg += '</g>'
    box_element_svg
  end

  def to_svg
    svg=<<~EOF
    <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' viewBox='0 0 #{doc_width} #{doc_height}' >
      <rect fill='white' x='0' y='0' width='#{doc_width}' height='#{doc_height}' />
      #{box_svg}
    </svg>
    EOF
  end

  private

  def copy_attributes_from_template
    section = Section.find(template_id)
    self.profile      = section.profile
    self.page_number  = section.page_number
    self.section_name  = section.section_name
    self.column       = section.column
    self.row          = section.row
    self.ad_type      = section.ad_type
    self.story_count  = section.story_count
    true
  end

end
