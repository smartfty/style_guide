
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
class Category
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
  has_one :Category, Category
  has_one :Region, String
  has_one :Class, String, tag: 'Class'
  has_one :Credit, String
  has_one :Source, String

  def to_hash
    h = {}
    h[:urgency] = self.Urgency if self.Urgency
    h[:category] = self.Category.to_hash if self.Category
    h[:region] = self.Region if self.Urgency
    h[:class] = self.Class.to_s if self.Class
    h[:credit] = self.Credit if self.Credit
    h[:source] = self.Source if self.Source
    h
  end
end

class NewsContent
  include HappyMapper
  tag 'NewsContent'
  has_one :Title, String
  has_one :SubTitle, String
  has_one :Body, String

  def to_hash
    h = {}
    h[:title]     = self.Title if self.Title
    h[:subtitle]  = self.SubTitle if self.SubTitle
    h[:body]      = self.Body if self.Body
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
end
#

# news_content = NewsContent.parse(NewsContent_XML)
# puts news_content.Title
# puts news_content.Body

# ytm = YNewsML.parse(YTM_XML)
# puts ytm.to_hash
directory = "/Users/mskim/Development/style_guide/public/wire_source/101_KOR/20181010"
puts File.exist? directory
xml_file = Dir.glob("#{directory}/*.xml").first
# puts xml_file
xml = File.open(xml_file, 'r'){|f| f.read}

puts yml = YNewsML.parse(xml).to_hash

# Dir.glob("#{directory}/*.xml").each do |f|
#   xml = File.open(f, 'r'){|f| f.read}
#   yml = YNewsML.parse(xml).to_hash
#   puts yml
#   # yml_path = f.sub(".xml", ".yml")
#   # File.open(yml_path, 'w'){|f| f.write yml}
# end


# describe YNewsML do
#   it "parses xml file" do
#     f = 
#     xml = File.open(f, 'r'){|f| f.read}
#     YNewsML.parse(xml).to_hash
#     parser = YNewsML.new(File.dirname(__FILE__) + '/sample.xml')
#     expect(parser.hash).to be_instance_of(Hash)
#     # expect(parser).to be_instance_of(Hash)
#   end
# end


# require 'active_support/core_ext'
# require 'xml/to/json'
# require 'json'
# xml = Nokogiri::XML xml
# puts JSON.pretty_generate(xml.root) # Use xml for information about the document, like DTD and stuff


# npm install -g xml2json-cli