# == Schema Information
#
# Table name: sections
#
#  id                           :integer          not null, primary key
#  profile                      :string
#  column                       :integer
#  row                          :integer
#  order                        :integer
#  ad_type                      :string
#  is_front_page                :boolean
#  story_count                  :integer
#  page_number                  :integer
#  section_name                 :string
#  color_page                   :boolean          default(FALSE)
#  publication_id               :integer          default(1)
#  layout                       :text
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  draw_divider                 :boolean
#  path                         :string
#  grid_width                   :float
#  grid_height                  :float
#  lines_per_grid               :float
#  width                        :float
#  height                       :float
#  left_margin                  :float
#  top_margin                   :float
#  right_margin                 :float
#  bottom_margin                :float
#  gutter                       :float
#  page_heading_margin_in_lines :integer
#  article_line_thickness       :float
#

class Section < ApplicationRecord

  belongs_to :publication, optional: true
  has_one :page_plan
  has_many :articles
  has_many :ad_box_templates

  after_create :setup
  before_create :parse_profile

  include PageSplitable
  include RectUtiles

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    save_section_config_yml
    # calling create_articles give validation error Section must exist!!! 
    # so call it in controller create, and update action
    # update_section_layout
  end

  def path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}"
  end

  #path from public
  def relative_path
    "/#{publication_id}/section/#{page_number}/#{profile}/#{id}"
  end

  def pdf_image_path
    relative_path + "/section.pdf"
  end

  def pdf_path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}/section.pdf"
  end

  def jpg_image_path
    relative_path + "/section.jpg"
  end

  def jpg_path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}/section.jpg"
  end

  def page_heading_path
    path + "/heading"
  end

  def page_headig_layout_path
    page_heading_path + "/layout.rb"
  end

  def page_heading_width
    width
  end

  def korean_date_string
    if page_number == 1
      "2017년 5월 11일 목요일 (4200호)"
    else
      "2017년 5월 11일 목요일"
    end
  end

   def self.create_section_with(options={})
    if s = Section.where(options).first
      s
    else
      s = Section.where(options).create
    end
  end

  def section_config_hash
    h = {}
    h['section_name']                   = section_name
    h['page_heading_margin_in_lines']   = page_heading_margin_in_lines
    h['ad_type']                        = ad_type || "no_ad"
    h['is_front_page']                  = is_front_page
    h['profile']                        = profile
    h['section_id']                     = id
    h['page_columns']                   = column
    h['grid_size']                      = [grid_width, grid_height]
    h['lines_per_grid']                 = lines_per_grid
    h['width']                          = width
    h['height']                         = height
    h['left_margin']                    = left_margin
    h['top_margin']                     = top_margin
    h['right_margin']                   = right_margin
    h['bottom_margin']                  = bottom_margin
    h['gutter']                         = gutter
    h['story_frames']                   = eval(layout)
    h['article_line_thickness']         = article_line_thickness
    h['draw_divider']                   = draw_divider
    h
  end


  def bottom_article?(article)
    article_bottom_grid     = article.grid_y + article.row
    article_x_grid          = article.grid_x
    article_y_grid          = article.grid_y
    return true if article_bottom_grid == row
    ad_box = ad_box_templates.first
    return false if ad_box.nil?
    ad_box_x_max_grid       = ad_box.grid_x + ad_box.column
    if ad_box.grid_y == article_bottom_grid && ad_box.grid_x <= article_x_grid && article_x_grid <= ad_box_x_max_grid
      return true
    end
    false
  end


  def self.update_section_configs
    Section.all.each do |section|
      section.save_section_config_yml
    end
  end

  def save_section_config_yml
    system "mkdir -p #{path}" unless File.directory?(path)
    section_config_yml_path = path + "/config.yml"
    yaml = section_config_hash.to_yaml
    File.open(section_config_yml_path, 'w'){|f| f.write yaml}
  end

  def article_type(box)
    if box.length == 5
      h = box[4]
      return '기고'       if h[4] == '기고'
      return 'opinion'   if h[4] == 'opinion'
      return '사설'       if h[4] == '사설'
      return 'editorial' if h[4] == 'editorial'
      return 'ad'        if h[4] =~ /^광고/
      return 'ad'        if h[4] =~ /^ad/
    end
    'article'
  end

  def self.update_page_headings
    Section.all.each do |sec|
      sec.copy_page_heading
    end
  end

  def copy_page_heading
    page_heading_template_path = "#{Rails.root}/public/#{publication_id}/page_heading/#{page_number}"
    page_heading_path = path + "/heading"
    system "cp -R #{page_heading_template_path}/ #{page_heading_path}"
  end

  def sample_ad_path
    "#{Rails.root}/public/#{publication_id}/ad/sample/#{ad_type}"
  end

  def ad_folder
    path + "/ad"
  end

  def delete_pdf_ad
    pdf_ad_path = ad_folder + "/output.pdf"
    jpg_ad_path = ad_folder + "/output.jpg"
    system "rm #{pdf_ad_path}"
    system "rm #{jpg_ad_path}"
  end

  def copy_ad
    return unless ad_type
    ad_template_path = "#{Rails.root}/public/#{publication_id}/ad/#{column}/#{ad_type}"
    ad_folder = path + "/ad"
    system "cp -R #{ad_template_path}/ #{ad_folder}"
    #code
  end

  def copy_sample_ad
    # copy random asmple ad
    ad = Dir.glob("#{sample_ad_path}/*{.jpg,.pdf}").sample
    puts "sample_ad_path:#{sample_ad_path}"
    puts "ad:#{ad}"
    puts "cp #{ad} #{ad_folder}/images/1.jpg"
    if ad
      system "cp #{ad} #{ad_folder}/images/1.jpg"
    end
  end

  def update_section_layout
    update_profile
    save_section_config_yml
    copy_page_heading
    create_articles
    generate_article_pdf
    generate_ad_box_template_pdf
    generate_pdf
  end

  def update_section_layout_if
    return if File.exist?(pdf_path)
    update_profile
    save_section_config_yml
    copy_page_heading
    create_articles
    generate_article_pdf
    generate_ad_box_template_pdf
    generate_pdf
  end

  def regerate_section_preview
    copy_page_heading
    generate_article_pdf
    generate_ad_box_template_pdf
    generate_pdf
  end

  def generate_article_pdf
    articles.each do |article|
      article.generate_pdf
    end
  end

  def generate_ad_box_template_pdf
    ad_box_templates.each do |ad|
      ad.generate_pdf
    end
  end

  def clear_section_pdf
    system("rm ##{pdf_path}")
  end

  def regenerate_pdf
    articles.each do |article|
      article.generate_pdf
    end
    generate_pdf
  end

  def self.generate_pdf
    Section.all.each do |sec|
      sec.generate_pdf
    end
  end

  def generate_heading_pdf
    PageHeading.generate_pdf(self)
  end

  def generate_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section ."
  end

  def svg_unit_width
    210/column
  end

  def svg_unit_height
    20
  end

  def svg_box
    # TODO put story number on top
    # make width for 6 column same as 7 column
    string = ""
    eval_layout.each do |box|
      next if box.class == Hash
      if box.length == 5
        if box[4] == 'heading' || box[4] == '제목'
          # heading box
          string += "<rect fill='gray' stroke='#000000' x='#{box[0]*svg_unit_width}' y='#{box[1]*svg_unit_height}' width='#{box[2]*svg_unit_width}' height='#{box[3]*svg_unit_height}'/>\n"
        elsif box[4] == 'image'
          puts "place image here ..."
        elsif box[4] || box[4] == '광고'
          # ad box
          string += "<rect fill='red' stroke='#000000' x='#{box[0]*svg_unit_width}' y='#{box[1]*svg_unit_height}' width='#{box[2]*svg_unit_width}' height='#{box[3]*svg_unit_height}'/>\n"
        else
          string += "<rect fill='lightGray' stroke='#000000' stroke-width='4' x='#{box[0]*svg_unit_width}' y='#{box[1]*svg_unit_height}' width='#{box[2]*svg_unit_width}' height='#{box[3]*svg_unit_height}'/>\n"
        end
      else
        # article box
        string += "<rect fill='lightGray' stroke='#000000' stroke-width='4' x='#{box[0]*svg_unit_width}' y='#{box[1]*svg_unit_height}' width='#{box[2]*svg_unit_width}' height='#{box[3]*svg_unit_height}'/>\n"
      end
    end
    string
  end

  def to_svg
    svg=<<~EOF
    <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0' y='0' stroke='black' stroke-width='4' width='#{column*svg_unit_width}' height='#{row*svg_unit_height}'>
      #{svg_box}
    </svg>
    EOF
  end

  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        # get rif of id, created_at, updated_at
        # header = %w[page_number section_name profile column row order ad_type is_front_page story_count color_page draw_divider publication_id layout]
        header = %w[page_number  column  ad_type  layout]
        csv << header
        all.each do |item|
          csv << item.attributes.values_at(*header)
        end
      end
  end

  def self.to_hash_list(options = {})
      section_list = []
      filtered = column_names.dup
      filtered.shift  # remove id
      filtered.pop    # remove created_at
      filtered.pop    # remove updated_at
      all.each do |item|
        section_list << Hash[filtered.zip item.attributes.values_at(*filtered)]
      end
      section_list
  end

  def save_current_sections
    section_list = Section.to_hash_list
    # save yml
    yml_path = "#{Rails.root}/public/1/section/sections.yml"
    File.open(yml_path, 'w'){|f| f.write section_list.to_yaml}
    # save rb
    rb_path = "#{Rails.root}/public/1/section/sections.rb"
    File.open(rb_path, 'w'){|f| f.write section_list.to_s}
    # save csv
    csv_path = "#{Rails.root}/public/1/section/sections.csv"
    File.open(csv_path, 'w'){|f| f.write Section.to_csv.to_s}
  end

  def eval_layout
    eval(layout)
  end

  # other SectionTemplate choices for current page
  def other_choices
    SectionTemplate.where(page_number: page_number).all
  end

  def make_profile
    profile = "#{column}x15_"
    profile += "H_" if is_front_page
    profile += "#{ad_type}_" if ad_type
    profile += story_count.to_s
    profile
  end


  def has_overlapping_rect?
    #code
  end

  def has_pdf_error?
    return true unless File.exist?(pdf_path)
    false
  end

  def self.section_with_pdf_error
    pdf_error_sections = []
    Section.all.each do |section|
      # section.has_overlapping_rect?
      if section.has_pdf_error?
        pdf_error_sections << section.id
        pdf_error_sections << section.path
      end
    end
    pdf_error_sections
  end

  # prefered page for specific page_number
  def create_articles
    puts "id:#{id}"
    puts "self.id:#{self.id}"
    article_count = 0
    box_array = eval_layout

    # delete unused articles

    if box_array.length < articles.count
      unused_count = articles.count - box_array.length
      sorted = articles.sort_by{|a| a.order}
      unused_count.times do 
        article_from_last = sorted.pop
        # system("rm -rf #{article_from_last.path}")
        article_from_last.destroy
      end
    end
    box_array.each_with_index do |box, i|
      article_atts = {}
      article_atts[:section_id]  = self.id
      article_atts[:profile]  = self.profile
      article_atts[:grid_x]   = box[0]
      article_atts[:grid_y]   = box[1]
      article_atts[:column]   = box[2]
      article_atts[:row]      = box[3]
      article_atts[:order]    = article_count + 1
      article_atts[:kind]     = '기사'
      article_atts[:is_front_page]  = false
      article_atts[:is_front_page]  = true if is_front_page
      article_atts[:top_story]      = false
      article_atts[:top_story]      = true if article_atts[:order] == 1
      article_atts[:top_position]   = false
      article_atts[:top_position]   = true if box[1] == 0
      article_atts[:top_position]   = true if is_front_page && box[1] == 1
      article_atts[:on_left_edge]   = false
      article_atts[:on_left_edge]   = true if box[0] == 0
      article_atts[:on_right_edge]  = false
      article_atts[:on_right_edge]  = true if box[0] + box[2] == column
      article_atts[:page_heading_margin_in_lines]  = page_heading_margin_in_lines
      
      if box.last =~/^extend/
        article_atts[:extended_line_count] = box.last.split("_")[1].to_i
      elsif box.last =~/^push/
        article_atts[:pushed_line_count] = box.last.split("_")[1].to_i
      end
      article_atts[:section_id]   = self.id
      article_atts[:section]   = self
      current_rect = [box[0], box[1], box[2], box[3]]
      if box.length >= 5
        if box[4] =~/^광고/ || box[4] =~/^ad/
          ad_box_atts = {}
          ad_box_atts[:section_id]   = self.id
          ad_box_atts[:grid_x]   = box[0]
          ad_box_atts[:grid_y]   = box[1]
          ad_box_atts[:column]   = box[2]
          ad_box_atts[:row]      = box[3]
          ad_box_atts[:ad_type]   = box[4].split("_")[1]
          if ad_box = ad_box_templates.first
            ad_box.update(ad_box_atts)
            ad_box.generate_pdf
          else
            AdBoxTemplate.where(ad_box_atts).create!
          end
        else
          article_atts[:kind] = box[4]
          article = nil
          if article_with_order = articles.where(order: article_count + 1).first
            article_with_order.update(article_atts)
            article_with_order.generate_pdf
            current_article = article_with_order
          else
            current_article = Article.where(article_atts).create!
          end
          article_count += 1
          overlap = parse_overlap(current_article.grid_rect, i)
          embedded = parse_embedded(current_rect, i)
        end
      else
        article_atts[:kind] = '기사'
        if article_with_order = articles.where(order: article_count + 1).first
          article_with_order.update(article_atts)
          article_with_order.generate_pdf
          current_article = article_with_order
        else
          current_article = Article.where(article_atts).create!
        end
        article_count += 1
        overlap = parse_overlap(current_rect, i)
        embedded = parse_embedded(current_rect, i)
      end 
      # overlap means current article is overlapping with in another box, usually with ad_box
      if current_article && overlap
        current_article.overlap = overlap 
        current_article.save
      end
      # embedded is true means current article is embedded in another article area
      if current_article && embedded
        current_article.embedded = true 
        current_article.save
      end
    end
  end


  def parse_story_count
    count = 0
    box_array = eval_layout
    box_array.each_with_index do |box, i|
      if box.length >= 5  && (box[4] == '기고' || box[4] == 'opinion' || box[4] == '사설' || box[4] == 'editorial')
        count += 1
      elsif box.length == 5 && box[4] =~ /^광고/
        self.ad_type = box[4].split("_")[1]
      else
        count += 1
      end
    end
    count
  end

  def parse_ad_type
    box_array = eval_layout
    ad_type = ""
    box_array.each_with_index do |box, i|
      if box.length >= 5 && box[4] =~ /^광고/
        ad_type = box[4].split("_")[1]
      end
    end
    ad_type
  end

  def update_profile
    self.story_count = parse_story_count
    self.ad_type     = parse_ad_type
    self.profile     = e
    self.save
    puts "__________ after profile:#{profile}"

    self
  end

  def description
    "#{column}단 기사:#{story_count}개"
  end

  def re_order_layout
    layout_array = eval_layout
    self.layout = layout_array.sort_by {|rect| [rect[1], rect[0]]}.to_s
  end

  private
  def parse_profile
    layout_array = eval_layout
    self.layout = layout_array.sort_by {|rect| [rect[1], rect[0]]}.to_s
    if page_number == 1 || is_front_page == true
      self.is_front_page                    = true
      self.page_heading_margin_in_lines     = publication.front_page_heading_margin
    elsif PAGES_WITH_4_LINE_HEADING.include?(page_number) #[18,19,22,23]
      self.page_heading_margin_in_lines     = 4
    else
      self.is_front_page  = false
      self.page_heading_margin_in_lines     = publication.inner_page_heading_height 
    end
    self.row                    = 15
    self.story_count            = parse_story_count
    self.ad_type                = parse_ad_type
    self.profile                = make_profile
    self.grid_width             = publication.grid_width(column)
    self.grid_height            = publication.grid_height
    self.lines_per_grid         = publication.lines_per_grid
    self.width                  = publication.width
    self.height                 = publication.height
    self.left_margin            = publication.left_margin
    self.top_margin             = publication.top_margin
    self.right_margin           = publication.right_margin
    self.bottom_margin          = publication.bottom_margin
    self.gutter                 = publication.gutter
    self.article_line_thickness = publication.article_line_thickness
    self.publication_id         = publication.id
    true
  end
end
