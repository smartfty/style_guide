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
#  divider_position :integer
#  publication_id   :integer          default("1")
#  layout           :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Section < ApplicationRecord

  belongs_to :publication
  has_many :articles
  # validates :layout, uniqueness: true
  validates :layout, presence: true
  validates :column, presence: true
  validates :row, presence: true
  validates :divider_position, presence: true
  validates :publication_id, presence: true

  before_create :parse_layout
  after_create :setup
  # serialize :layout, Array
  scope :five_column, -> {where("column==?", 5)}
  scope :six_column, -> {where("column==?", 6)}
  scope :seven_column, -> {where("column==?", 7)}


  def path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}"
  end

  def pdf_image_path
    "/#{publication.id}/section/#{page_number}/#{profile}/#{id}/section.pdf"
  end

  def pdf_path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}/section.pdf"
  end

  def jpg_image_path
    "/#{publication.id}/section/#{page_number}/#{profile}/#{id}/section.jpg"
  end

  def jpg_path
    "#{Rails.root}/public/#{publication_id}/section/#{page_number}/#{profile}/#{id}/section.jpg"
  end

  def section_rakefile_template_path
    "#{Rails.root}/public/template/Rakefile"
  end

  def setup
    system "mkdir -p #{path}" unless File.directory?(path)
    update_section_layout
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
    h['grid_size']        = [grid_width, grid_height]
    h['width']            = publication.width
    h['height']           = publication.height
    h['story_frames']     = eval(layout)
    h['left_margin']      = publication.left_margin
    h['top_margin']       = publication.top_margin
    h['right_margin']     = publication.right_margin
    h['bottom_margin']    = publication.bottom_margin
    h['gutter']           = publication.gutter
    h['divider_info']     = publication.divider_info(column)
    h
  end

  def save_section_config_yml
    system "mkdir -p #{path}" unless File.directory?(path)
    section_config_yml_path = path + "/config.yml"
    File.open(section_config_yml_path, 'w'){|f| f.write section_config_hash.to_yaml}
  end


  def section_rakefile_template_path
    "#{Rails.root}/public/section_template/Rakefile"
  end

  def copy_rakefile
    rakefile_path = path + "/Rakefile"
    system "cp #{section_rakefile_template_path} #{rakefile_path}"
    # File.open(rakefile_path, 'w'){|f| f.write rakefile_content}
    #code
  end

  def save_article_without_template(path, column, row)
    #TODO
  end

  def article_type(box)
    if box.length == 5 && box[4].class == Hash
      h = box[4]
      return '제목'  if h[:타입] == '제목'
      return '광고'  if h[:광고]
    end
    'article'
  end

  def copy_page_heading
    page_heading_template_path = "#{Rails.root}/public/#{publication_id}/page_heading/#{page_number}"
    page_heading_path = path + "/heading"
    system "cp -R #{page_heading_template_path}/ #{page_heading_path}"
  end

  def copy_articles
    eval_layout.each_with_index do |rect, i|
      type = article_type(rect)
      article_template_path = "#{Rails.root}/public/#{publication_id}/#{column}/#{rect[2]}x#{rect[3]}"
      if type == 'article'
        if i == 0
          # for top_story
          if is_front_page || page_number == 1
            article_template_path += "/4"
          else
            article_template_path += "/3"
          end
        elsif rect[1] == 1 &&  page_number == 1 # if the box is at y == 1, top_position for front page
          article_template_path += "/2"
        elsif rect[1] == 0 # if the box is at y == 0, top_position
          article_template_path += "/1"
        else
          # reqular article box
          article_template_path += "/0"
          #code
        end
      end

      unless  File.directory?(article_template_path)
        puts "#{article_template_path} doesn't exist!!!!!"
        #TODO create article
        article_path = path + "/#{i+1}"
        save_article_without_template(article_path, rect[2], rect[3])
        next
      end

      article_path = path + "/#{i+1}"
      puts "article_path:#{article_path}"
      puts "cp -R #{article_template_path}/ #{article_path}"
      system "cp -R #{article_template_path}/ #{article_path}"
    end
  end

  def sample_ad_path
    "#{Rails.root}/public/#{publication_id}/ad/sample/#{ad_type}"
  end

  def ad_folder
    path + "/ad"
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

  def update_section_layout
    puts __method__
    save_section_config_yml
    copy_page_heading
    copy_articles
    copy_ad
    copy_sample_ad
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

  private

  # prefered page for specific page_number
  def parse_layout
    count = 0
    box_array = eval_layout
    self.column       = 7         unless self.column
    self.row          = 15        unless self.row
    # self.color_page   = false     unless self.color_page
    self.is_front_page  = is_front_page if is_front_page
    self.is_front_page  = true if page_number == 1
    self.ad_type        = ad_type if ad_type
    box_array.each do |box|
      if box.length == 5 && box[4].class == Hash
        h = box[4]
        self.is_front_page = true   if h[:타입] == '제목'
        self.ad_type = h[:type].gsub(" ","-")     if h[:type]
        self.ad_type = h[:광고].gsub(" ","-")      if h[:광고]
        # TODO create Special Box Object here
      else
        # TODO create Nomal Article Object here
        count += 1
      end
      self.story_count = count
    end
    self.profile = make_profile
    true
  end

end
