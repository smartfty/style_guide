# == Schema Information
#
# Table name: sections
#
#  id               :integer          not null, primary key
#  profile          :string
#  column           :integer
#  row              :integer
#  order            :integer
#  ad_type          :string
#  is_front_page    :boolean
#  story_count      :integer
#  page_number      :integer
#  section_name     :string
#  color_page       :boolean          default("f")
#  publication_id   :integer          default("1")
#  layout           :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Section < ApplicationRecord

  belongs_to :publication, optional: true
  has_many :articles
  has_many :ad_box_templates
  # validates :profile, presence: true
  # validates :layout, presence: true
  # validates :column, presence: true
  # validates :row, presence: true
  # validates :publication_id, presence: true
  # before_create :check_status
  # after_save :parse_layout
  # after_create :setup
  # serialize :layout, Array
  scope :five_column, -> {where("column==?", 5)}
  scope :six_column, -> {where("column==?", 6)}
  scope :seven_column, -> {where("column==?", 7)}


  def path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}"
  end

  #path from public
  def relative_path
    "/#{publication.id}/section/#{page_number}/#{profile}/#{id}"
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

  def page_headig_path
    path + "/page_heading"
  end

  def setup
    puts "in section setup"
    # system "mkdir -p #{path}" unless File.directory?(path)
    # update_section_layout
  end

  def section_config_hash
    h = {}
    # h[:issue] = issue.issue_number
    h['date']  = Date.new(2017,4,10)
    h['section_name'] = section_name
    if page_number == 1 || is_front_page == true
      h['is_front_page']  = true
    else
      h['is_front_page']  = false
    end
    h[:ad_type] = ad_type || "no_ad"
    # grid_key: 7x12/H/5
    grid_width            = publication.grid_width(column)
    grid_height           = publication.grid_height
    h['page_columns']     = column
    h['grid_size']        = [grid_width, grid_height]
    h['width']            = publication.width
    h['height']           = publication.height
    h['left_margin']      = publication.left_margin
    h['top_margin']       = publication.top_margin
    h['right_margin']     = publication.right_margin
    h['bottom_margin']    = publication.bottom_margin
    h['gutter']           = publication.gutter
    h['divider_info']     = publication.divider_info(column)
    h['story_frames']     = eval(layout)
    h
  end

  def save_section_config_yml
    system "mkdir -p #{path}" unless File.directory?(path)
    section_config_yml_path = path + "/config.yml"
    File.open(section_config_yml_path, 'w'){|f| f.write section_config_hash.to_yaml}
  end

  def article_type(box)
    if box.length == 5 && box[4].class == Hash
      h = box[4]
      return 'title'  if h[:타입] == '제목'
      return 'title'  if h[:type] == 'title'
      return 'ad'  if h[:광고]
      return 'ad'  if h[:ad_type]
    end
    'article'
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
    save_section_config_yml
    copy_page_heading
    create_articles
    generate_article_pdf
    generate_ad_box_template_pdf
    # copy_ad
    # copy_sample_ad
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

  def regenerate_secrion_pdf
    articles.each do |article|
      article.generate_pdf
    end
    generate_pdf
  end

  def generate_pdf
    system "cd #{path} && /Applications/newsman.app/Contents/MacOS/newsman section_pdf ."
  end

  def svg_box
    # TODO put story number on top
    # make width for 6 column same as 7 column
    string = ""
    eval_layout.each do |box|
      next if box.class == Hash
      if box.length == 5 && box[4].class == Hash
        if box[4][:type] == 'heading' || box[4]['타입'] == '제목'
          # heading box
          string += "<rect fill='gray' stroke='#000000' x='#{box[0]*svg_unit_width}' y='#{box[1]*svg_unit_height}' width='#{box[2]*svg_unit_width}' height='#{box[3]*svg_unit_height}'/>\n"
        elsif box[4][:type] == 'image'
          puts "place image here ..."
        elsif box[4][:ad] || box[4]['타입'] == '광고'
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
    <svg xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0' y='0' width='#{column*svg_unit_width}' height='#{row*svg_unit_height}'>
      #{svg_box}
    </svg>
    EOF
  end

  def self.to_csv(options = {})
      CSV.generate(options) do |csv|
        # get rif of id, created_at, updated_at
        filtered = column_names.dup
        filtered.shift
        filtered.pop
        filtered.pop
        csv << filtered
        all.each do |item|
          csv << item.attributes.values_at(*filtered)
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
    profile = "#{column}x#{row}_"
    profile += "H_" if is_front_page
    profile += "#{ad_type}_" if ad_type
    profile += story_count.to_s
    profile
  end

  def svg_unit_width
    30
  end

  def svg_unit_height
    20
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
    count = 0
    box_array = eval_layout
    box_array.each_with_index do |box, i|
      article_atts = {}
      article_atts[:section_id]  = self.id
      article_atts[:column]   = box[2]
      article_atts[:row]      = box[3]
      article_atts[:order]    = i + 1
      article_atts[:is_front_page]  = false
      article_atts[:is_front_page]  = true if is_front_page
      article_atts[:top_story]      = false
      article_atts[:top_story]      = true if article_atts[:order] == 1
      article_atts[:top_position]   = false
      article_atts[:top_position]   = true if box[1] == 0
      article_atts[:top_position]   = true if is_front_page && box[1] == 1
      if box.length == 5 && box[4].class == Hash
        h = box[4]
        ad_box_atts = {}
        ad_box_atts[:section_id]   = self.id
        ad_box_atts[:column]   = box[2]
        ad_box_atts[:row]      = box[3]
        ad_box_atts[:order]    = i + 1
        ad_box_atts[:ad_type]   = h[:type].gsub(" ","-")     if h[:type]
        ad_box_atts[:ad_type]   = h[:광고].gsub(" ","-")      if h[:광고]
        AdBoxTemplate.where(ad_box_atts).first_or_create!
      else
        article_atts[:on_left_edge] = false
        article_atts[:on_left_edge] = true if box[0] == 0
        article_atts[:on_right_edge] = false
        article_atts[:on_right_edge] = true if box[0] + box[2] == column
        Article.where(article_atts).first_or_create!
        count += 1
      end
    end
  end

end
