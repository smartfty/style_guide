# require 'happymapper'
# require 'yaml'

# class Header
#   include HappyMapper
#   tag 'Header'
#   element :Action, String, tag: 'Action'
#   element :ServiceType, String, tag: 'ServiceType'
#   element :ContentID, String, tag: 'ContentID'
#   element :SendDate, String, tag: 'SendDate'
#   element :SendTime, String, tag: 'SendTime'

#   def to_hash
#     h = {}
#     h[:action] = self.Action if self.Action
#     h[:service_type] = self.ServiceType if self.ServiceType
#     h[:content_id] = self.ContentID if self.ContentID
#     h[:date] = self.SendDate if self.SendDate
#     h[:time] = self.SendTime if self.SendTime
#     h
#   end
# end
# #
# class Category
#   include HappyMapper
#   tag 'Category'

#   attribute :code, String, tag: 'code'
#   attribute :name, String, tag: 'name'

#   def to_s
#     # h = {}
#     # h[:code]     = self.code if self.code
#     s  = ""
#     s  = self.name if self.name
#     s
#   end
# end

# class ClassCode
#   include HappyMapper
#   tag 'ClassCode'
#   attribute :code, String, tag: 'code'
#   attribute :name, String, tag: 'name'
#   def to_hash
#     h = {}
#     h[:code]     = self.code if self.code
#     h[:name]     = self.name if self.name
#     h
#   end
# end

# class Class
#   include HappyMapper
#   tag 'Class'
#   has_many :class_codes, ClassCode

#   def to_hash
#     h = []
#     if class_codes
#       class_codes.each do |class_code|
#         h << class_code.to_hash 
#       end
#     end
#     h
#   end

# end

# class Metadata
#   include HappyMapper
#   tag 'Metadata'
#   has_one :Urgency, String
#   has_one :Category, Category
#   has_one :Region, String
#   # has_one :Class, Class, tag: 'Class'
#   has_one :Credit, String
#   has_one :Source, String

#   def to_hash
#     h = {}
#     h[:urgency] = self.Urgency if self.Urgency
#     h[:category] = self.Category.to_s if self.Category
#     h[:region] = self.Region if self.Urgency
#     # h[:class_code] = self.Class.to_s if self.Class
#     h[:credit] = self.Credit if self.Credit
#     h[:source] = self.Source if self.Source
#     h
#   end
# end

# class NewsContent
#   include HappyMapper
#   tag 'NewsContent'
#   has_one :Title, String
#   # has_one :Subtitle, String
#   has_one :Body, String
#   has_one :MultiMedia, String

#   def to_hash
#     h = {}
#     h[:title]     = self.Title if self.Title
#     # h[:subtitle]  = self.Subtitle if self.Subtitle
#     h[:body]      = self.Body if self.Body
#     h[:picture]   = self.MultiMedia if self.MultiMedia
#     h
#   end
# end

# class YNewsML
#   include HappyMapper
#   tag 'YNewsML'
#   has_one :Header, Header
#   has_one :Metadata, Metadata
#   has_one :NewsContent, NewsContent
#   # has_one :link, String, xpath: 'Header'

#   def to_hash
#     h = self.Header.to_hash
#     h.merge! self.Metadata.to_hash
#     h.merge! self.NewsContent.to_hash
#     h
#   end
# end

# namespace :wire do
#   desc 'seed stories'
#   task :seed_wire =>:environment do

#     source = "#{Rails.root}/public/wire_source/101_KOR/20181010"
#     puts "parsing 101_KOR/20181010..."
#     Dir.glob("#{source}/*.xml").each do |f|
#       xml = File.open(f, 'r'){|f| f.read}
#       h = YNewsML.parse(xml).to_hash
#       puts "f:#{f}"
#       # YhArticle.create!(h)
#     end


#     source = "#{Rails.root}/public/wire_source/201_PHOTO_YNA/20181010"
#     puts "parsing 201_PHOTO_YNA/20181010..."
#     Dir.glob("#{source}/*.xml").each do |f|
#       xml = File.open(f, 'r'){|f| f.read}
#       h = YNewsML.parse(xml).to_hash
#       YhPicture.create!(h)
#     end
#   end
# end
