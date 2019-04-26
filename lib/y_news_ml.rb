
require 'happymapper'
require 'yaml'
require 'pry'
# require 'respec/autorun'
#

class Header
  include HappyMapper
  tag 'Header'
  element :Action, String, tag: 'Action'
  element :ServiceType, String, tag: 'ServiceType'
  element :ContentID, String, tag: 'ContentID'
  element :SendDate, String, tag: 'SendDate'
  element :SendTime, String, tag: 'SendTime'

  def to_hash
    h = {}
    h[:action] = self.Action if self.Action
    h[:service_type] = self.ServiceType if self.ServiceType
    h[:content_id] = self.ContentID if self.ContentID
    h[:date] = self.SendDate if self.SendDate
    h[:time] = self.SendTime if self.SendTime
    h
  end
end
#
class CodeCategory
  include HappyMapper
  tag 'Category'

  attribute :code, String, tag: 'code'
  attribute :name, String, tag: 'name'

  def to_hash
    h = {}
    h[:code]     = self.code if self.code
    h[:name]     = self.name if self.name
    h
  end
end

class ClassCode
  include HappyMapper
  tag 'ClassCode'
  attribute :code, String, tag: 'code'
  attribute :name, String, tag: 'name'
  def to_hash
    h = {}
    h[:code]     = self.code if self.code
    h[:name]     = self.name if self.name
    h
  end
end

class Class
  include HappyMapper
  tag 'Class'
  has_many :class_codes, ClassCode

  def to_hash
    h = []
    class_codes.each do |class_code|
      h << class_code.to_hash 
    end
    # h[:class_code]     = self.class_code if self.class_code
    h
  end
end

class Metadata
  include HappyMapper
  tag 'Metadata'
  has_one :Urgency, String
  has_one :Category, CodeCategory
  has_one :Region, String
  has_one :Class, String, tag: 'Class'
  has_one :Credit, String
  has_one :Source, String

  def to_hash
    h = {}
    h[:urgency] = self.Urgency if self.Urgency
    h[:category] = self.Category.to_hash if self.Category
    h[:region] = self.Region if self.Urgency
    # h[:class] = self.Class.to_s if self.Class
    h[:credit] = self.Credit if self.Credit
    h[:source] = self.Source if self.Source
    h
  end
end

class NewsContent
  include HappyMapper
  tag 'NewsContent'
  has_one :Title, String
  # has_one :SubTitle, String
  has_one :Body, String
  has_one :MultiMedia, String

  def to_hash
    h = {}
    h[:title]     = self.Title if self.Title
    # h[:subtitle]  = self.SubTitle if self.SubTitle
    h[:body]      = self.Body if self.Body
    h[:picture]   = self.MultiMedia if self.MultiMedia
    h
  end
end

class YNewsML
  include HappyMapper
  tag 'YNewsML'
  has_one :Header, Header
  has_one :Metadata, Metadata
  has_one :NewsContent, NewsContent
  # has_one :link, String, xpath: 'Header'

  def to_hash
    h = self.Header.to_hash
    h.merge! self.Metadata.to_hash
    h.merge! self.NewsContent.to_hash
    h
  end

  def self.new_ytn
    require 'date'
    today = Date.today
    today_string = today.strftime("%Y%m%d")
    source_location = '/Volumes/211.115.91.190'
    ytn_today_story_folder = source_location + "/101_KOR/#{today_string}"
    ytn_today_image_folder = source_location + "/201_PHOTO_YNA/#{today_string}"
    ytn_today_graphic_folder = source_location + "/203_GRAPHIC/#{today_string}"
    self.parse_new_wire_story_xml(ytn_today_story_folder)
    self.parse_new_wire_picture_xml(ytn_today_image_folder)
    self.parse_wire_wire_graphic_xml(ytn_today_graphic_folder)

    # delete files that are week old
    YhArticle.delete_week_old(today)
    YhPicture.delete_week_old(today)
    YhGraphic.delete_week_old(today)
  end
 

  def self.parse_new_wire_story_xml(source_dir)
    Dir.glob("#{source_dir}/*.xml").each do |xml_file|
      # first check if we have received the file
      content_id = File.basename(xml_file, ".xml")
      received = YhArticle.find_by(content_id: content_id)
      unless received
        xml = File.open(xml_file, 'r'){|f| f.read}
        story_hash = YNewsML.parse(xml).to_hash
        story_hash[:content_id] = content_id
        YhArticle.create(story_hash)
      end
    end
  end

  def self.parse_new_wire_picture_xml(source_dir)
    Dir.glob("#{source_dir}/*.xml").each do |xml_file|
      # first check if we have received the file
      content_id = File.basename(xml_file, ".xml")
      received = YhPicture.find_by(content_id: content_id)
      unless received
        xml = File.open(xml_file, 'r'){|f| f.read}
        picture_hash = YNewsML.parse(xml).to_hash
        picture_hash[:content_id] = content_id
        YhPicture.create(picture_hash)
      end
    end
  end


  def self.parse_new_wire_graphic_xml(source_dir)
    Dir.glob("#{source_dir}/*.xml").each do |xml_file|
      # first check if we have received the file
      content_id = File.basename(xml_file, ".xml")
      received = YhGraphic.find_by(content_id: content_id)
      unless received
        xml = File.open(xml_file, 'r'){|f| f.read}
        graphic_hash = YNewsML.parse(xml).to_hash
        graphic_hash[:content_id] = content_id
        YhGraphic.create(graphic_hash)
      end
    end
  end

  def self.load_ytn_sample
    self.parse_wire_story
    self.parse_wire_picture
    self.parse_wire_graphic
  end

  def self.parse_wire_story
    directory = "#{Rails.root}/public/wire_source/101_KOR/20190424"
    Dir.glob("#{directory}/*.xml").each do |xml_file|
      content_id = File.basename(xml_file, ".xml")
      received = YhArticle.find_by(content_id: content_id)
      unless received
        xml = File.open(xml_file, 'r'){|f| f.read}
        story_hash = YNewsML.parse(xml).to_hash
        story_hash[:content_id] = content_id
        YhArticle.create(story_hash)
      end    
    end
  end

  def self.parse_wire_picture
    directory = "#{Rails.root}/public/wire_source/201_PHOTO_YNA/20190424"
    puts "parsing 201_PHOTO_YNA/20181010..."
    Dir.glob("#{directory}/*.xml").each do |xml_file|
      content_id = File.basename(xml_file, ".xml")
      received = YhPicture.find_by(content_id: content_id)
      unless received
        xml = File.open(xml_file, 'r'){|f| f.read}
        picture_hash = YNewsML.parse(xml).to_hash
        picture_hash[:content_id] = content_id
        YhPicture.create(picture_hash)
      end
    end
  end

  def self.parse_wire_graphic
    directory = "#{Rails.root}/public/wire_source/203_GRAPHIC/20190424"
    puts "parsing 203_GRAPHIC/20190312..."
    Dir.glob("#{directory}/*.xml").each do |xml_file|
      content_id = File.basename(xml_file, ".xml")
      received = YhGraphic.find_by(content_id: content_id)
      unless received
        xml = File.open(xml_file, 'r'){|f| f.read}
        graphic_hash = YNewsML.parse(xml).to_hash
        graphic_hash[:content_id] = content_id
        YhGraphic.create(graphic_hash)
      end     
    end
  end
end
