module ArticleSaveXml
  extend ActiveSupport::Concern


## 뉴스 / 지면보기 XML 생성관련 소스 분리 2018-12-27 DaNiel

  def filter_to_title(title)
    return unless title
    title.strip!
    title.gsub!(/^\u3000/, "")
    title.gsub!(/ {2,8}/, " ")
    title
  end

  def filter_to_markdown(body_text)
    return unless body_text
    body_text.strip!
    # body_text.gsub!(/\s\s/, " ")
    # body_text.gsub!(/^\n\n/, "\n")
    body_text.gsub!(/\u200B/, "")
    body_text.gsub!(/^(\^|-\s)/, "")
    body_text.gsub!(/^\t/, "")
    body_text.gsub!(/^\n/, "")
    body_text.gsub!(/^\s/, "")
    body_text.gsub!(/^\u3000/, "")
    body_text.gsub!(/^\s*\n/m, "\n")
    body_text.gsub!(/^\s*#/, '#' )
    body_text.gsub!(/^\n/, "")
    body_text.gsub!(/(\n|\r\n)+/, "\n\n")
    # body_text.gsub!(/[.]\s\s\s+/, ".")
    # body_text.gsub!(/\.$\n\n/, ".")
    body_text.gsub!(/^\./, "")
    body_text.gsub!(/ {2,8}/, " ")
    body_text
  end

  def to_markdown_para
    # body.gsub!(/\s\s/, /\s/)
    body.gsub!(/^(\^|-\s)/, "")
    body.gsub!(/^\t/, "")
    body.gsub!(/^\n\n/, "")
    body.gsub!(/^\u3000/, "")
    body.gsub!(/^\s*\n/m, "\n")
    body.gsub!(/^\s*#/, '#' )
    body.gsub!(/$(\n|\r\n)+/, "\n\n" )
    body.gsub!(/(\n|\r\n)+/, "\n\n")
    self.save
  end

  def covert_euckr_not_suported_chars
    return unless body
    body.gsub!("\u200B", "")
    title.strip!
    title.gsub!("\u200B", "")
    body.gsub!("\u2027", "\u00b7")
    title.gsub!("\u2024", "\u00b7")
    body.gsub!("\u2024", "\u00b7")
    title.gsub!("\u00A0", " ")
    body.gsub!("\u2043", "-")
    body.gsub!("\u30FB", "\u00b7")
    body.gsub!("\u6DB8", "&#28088;")
    body.gsub!("\u9B92", "&#39826;")
    body.gsub!("\u00A0", " ")
    body.gsub!("\u2014", "&mdash;")
    title.gsub!("\u003C", "&lt;")
    title.gsub!("\u003E", "&gt;")
    body.gsub!("\u003C", "&lt;")
    body.gsub!("\u003E", "&gt;")
    body.gsub!("\uFF62", "&#65378;")
    body.gsub!("\uFF63", "&#65379;")
    body.gsub!("\u2613", "&#9747;")
    body.gsub!("\u9752", "&#38738;")
    body.gsub!("\u2014", "&#8212;")
    body.gsub!("\u2013", "&#8211;")
    title.gsub!("\u2014", "&#8212;")
    body.gsub!("\u5d1b", "&#23835;")
    body.gsub!("\u2003", "&#8195;")
    body.gsub!("\u2022", "&#183;")
    body.gsub!("\uCAD2", "&#51922;")
    body.gsub!("\uFF65", "&#65381;")
    body.gsub!("\u302e", "&#12334;")
    body.gsub!("\u5e26", "&#24102;")
    title.gsub!("\u5e26", "&#24102;")
    body.gsub!("\u2219", "&#8729;")
    title.gsub!("\u2219", "&#8729;")
    title.gsub!("\u0026", "&amp;")
    body.gsub!("\u0026", "&amp;")
    body.gsub!("\u0387", "\u00B7")
  end

  def newsml_issue_path
    "#{Rails.root}/public/1/issue/#{issue.date}/newsml"
  end
  
  def image_source
    if page_number == 22
      if kind == '기고'
        person = OpinionWriter.where(name:reporter).first
        name = person.name
        filtered_name = name
        filtered_name = name.split("_").first if name.include?("_")
        filtered_name = name.split("=").first if name.include?("=")
        puts "filtered_name : #{filtered_name}"
        return opinion_image_path + "/#{filtered_name}.jpg"
      elsif kind == '사설'
        person = Profile.where(name:reporter).first
        if person
          name = person.name
          return profile_image_path + "/#{name}.jpg"
        else
          return nil
        end
      end
    elsif page_number == 23
      if kind == '기고'
        person = OpinionWriter.where(name:reporter).first
        name = person.name
        filtered_name = name
        filtered_name = name.split("_").first if name.include?("_")
        filtered_name = name.split("=").first if name.include?("=")
        return opinion_image_path + "/#{filtered_name}.jpg"
      elsif kind == '사설'
        return nil
        # person = reporter_from_body
        # name = person.gsub(" ","")[0..2]
        # return opinion_image_path + "/#{name}.jpg"
      end
    end
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    hour  = updated_at.hour.to_s.rjust(2, "0")
    min   = updated_at.min.to_s.rjust(2, "0")
    sec   = updated_at.sec.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    updated_date      = "#{year}#{month}#{day}"
    @page_info        = page_number.to_s.rjust(2,"0")
    @jeho_info        = issue.number
    @date_id          = updated_date
    @photo_item       = "#{@date_id}_#{@jeho_info}_#{@page_info}_#{two_digit_ord}.jpg"
  end
  
  def two_digit_ord
    order.to_s.rjust(2, "0")
  end

  def story_xml_filename
    date_without_minus = issue.date.to_s.gsub("-","")
    two_digit_page_number = page_number.to_s.rjust(2, "0")
    "#{date_without_minus}.011001#{two_digit_page_number}0000#{two_digit_ord}.xml"
  end

  def save_story_xml
    FileUtils.mkdir_p(newsml_issue_path) unless File.exist? newsml_issue_path
    path = "#{newsml_issue_path}/#{story_xml_filename}"
    # story_xml.encode("utf-8").force_encoding("ANSI")
    covert_euckr_not_suported_chars
    File.open(path, 'w:euc-kr'){|f| f.write story_xml}
    save_xml_image 
  end

  def save_xml_image
    source = image_source
    return if source.nil?
    target = newsml_issue_path + "/#{@photo_item}"
    system("cp #{source} #{target}")
    if images.length > 0
      photo_file_orginal = "#{issue.path}/images/#{page_number}_#{order}_#{images.length-1}.*"
      photo_file_name = "#{page_number}_#{order}_#{images.length-1}.*" # images.length 가 아닌 현재 파일 오더?를 가져올 수 있어야할텐데...
      # if File.exist?(photo_file_orginal)
        #  system("cd #{issue.path}/images/ && convert #{photo_file_name} -resize 620 #{newsml_issue_path}/#{@photo_item}")
        system("cd #{issue.path}/images/ && sips -s format jpeg -s formatOptions best -Z 540 #{photo_file_name} --out #{newsml_issue_path}/#{@photo_item}")
      # end
      # return issue.path + "/images/#{photo_file_name}"
      return ""
    else graphics.length > 0
      graphic_file_orginal = "#{issue.path}/images/graphic_#{page_number}_#{order}_#{graphics.length-1}.pdf"
      graphic_file_name = "graphic_#{page_number}_#{order}_#{graphics.length-1}.pdf" # images.length 가 아닌 현재 파일 오더?를 가져올 수 있어야할텐데...
      # if File.exist?(graphic_file_orginal)
      system("cd #{issue.path}/images/ && convert -density 300 -resize 540 #{graphic_file_name} #{newsml_issue_path}/#{@photo_item}")
      # system("sips -s #{newsml_issue_path}/#{@photo_item}
      # system("cd #{issue.path}/images/ && sips -s format jpeg -s formatOptions best best -Z 620 #{graphic_file_name} --out #{newsml_issue_path}/#{@photo_item}")
      # end
        # return issue.path + "/images/#{graphic_file_name}"
      return ""
    end
  end

  def reporter_from_body
    # return unless reporter
    body.match(/^# (.*)/) if body && body !=""
    $1.to_s.sub("# ", "")
  end

  def story_xml # 내일닷컴(데스크탑용) 기사 xml 생성
    story_erb_path = "#{Rails.root}/public/1/newsml/story_xml.erb"
    story_xml_template = File.open(story_erb_path, 'r'){|f| f.read}
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    hour  = updated_at.hour.to_s.rjust(2, "0")
    min   = updated_at.min.to_s.rjust(2, "0")
    sec   = updated_at.sec.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    updated_date      = "#{year}#{month}#{day}"
    updated_time      = "#{hour}#{min}#{sec}+0900"
    @date_and_time    = "#{updated_date}T#{updated_time}"
    @date_id          = updated_date
    @news_key_id      = "#{updated_date}.011001#{page_info}0000#{two_digit_ord}"
    @day_info         = "#{year}년#{month}월#{day}일"
    @media_info       = publication.name
    # @edition_info     = page_number.to_s.rjust(2,"0")
    # @page_info        = publication.paper_size
    @page_info        = page_number.to_s.rjust(2,"0")
    @jeho_info        = issue.number
    # if page.section_name = '오피니언'
    #   @news_title_info = '논설'
    # else
    #   @news_title_info  = page.section_name
    # end
    @news_title_info  = page.section_name
      # reporter_record   = Reporter.where(name:reporter).first
      # if reporter_record
      #   @post             = reporter_record.reporter_group.name
      #   @gija_id          = email.split("@").first
      #   @email            = email
      # else
      #   @post             = "소속팀"
      #   @gija_id          = "기자아이디"
      #   @email            = "기자이메일"
      # end
    if reporter && reporter != ""  
     @name       = reporter
    else  
     @name       = reporter_from_body
    end
     # if @name =~/_/
      # @name = @name.split("_")[0]
      # end
    if images.length > 0 
      @image          = images.first
      @caption        = ""
      @caption        = "#{@image.caption_title} | " if @image.caption_title && @image.caption_title != ""
      @caption        += "#{@image.caption} " if @image.caption && @image.caption != ""
      @caption        += "#{@image.source}" if @image.source && @image.source != ""
      @h_caption_title = @image.caption_title
      @h_caption       = @image.caption
      @h_source        = @image.source
    end
    opinion_writer  = OpinionWriter.where(name:reporter).first
    if opinion_writer
      @work        = opinion_writer.work if opinion_writer.work
      @position       = opinion_writer.position if opinion_writer.position
      if @name =~/_/
        @name = @name.split("_")[0]
      end
      @by_line_body   = "<br><br>#{@name} #{@work} #{@position}"
      @by_line        = "#{@name} #{@work} #{@position}"
      @caption        = "#{@name} #{@work} #{@position}"
    end
    # reporter_record   = Reporter.where(name:reporter).first
    if page_number == 22 && order == 2
      profile         = Profile.where(name:@name).first
      if profile
        @work        = profile.work if profile.work
        @position       = profile.position if profile.position
        if @name =~/_/
          @name = @name.split("_")[0]
        end
        @by_line_body   = "<br><br>#{@name} #{@work} #{@position}"
        @by_line        = "#{@name} #{@work} #{@position}"  
        @caption        = "#{@name} #{@work} #{@position}"
      end
    end
    if page_number == 23 && order == 2
      @name          = reporter_from_body
      @by_line       = ''
      reporter       = Reporter.where(name: @name).first
      @email         = reporter.email if reporter
      @caption       = reporter_from_body
    end
    @section_name_code = section_name_code
    if subject_head && subject_head != ""
      subject_head.strip! 
      @name_plate       = eliminate_size_option(subject_head)
    else
      # r = OpinionWriter.where(name: reporter).first
      # puts r
      if page_number == 22 || page_number == 23
        category_code = opinion_writer.category_code 
        @name_plate = opinion_writer.title
      end
    end 
    @subject_ex_name  = @name_plate.gsub(/\[(.*)\]/){"#{$1}"} if @name_plate && @name_plate !=""  
    @money_status     = "30"
    if page_number == 22
      if kind == '사설'
        if subject_head == '기고'
          category_code = 2401
          @money_status = "0"
        elsif subject_head == '정치시평'
          category_code = 2201
        # elsif subject_head == '경제시평'
        #   category_code = 2202
        end
      end
    elsif page_number == 23
      if kind == '사설'
        category_code= 2101
      end
    end
    @subject_ex_code  = category_code
    @gisa_key         = "#{@date_id}991#{@page_info}#{two_digit_ord}"
    if body && body != ""
      @body_content     = body.gsub(/^####(.*)\n/){"<!-- #{$1} -->"}
      @body_content     = @body_content.gsub(/^####(.*)\^\n/){"<!-- #{$1} -->"} 
      @body_content     = @body_content.gsub(/^##(.*)\n/){"<b>#{$1}</b><br><br>"} 
      @body_content     = @body_content.gsub(/^#\s(.*)/){"#{$1}"} 
      @body_content     = @body_content.gsub(/\^$/){""} 
      @data_content     = @body_content.gsub("\n\n"){"<br><br>"} 
    end
    # title.gsub!("\u2024", "")
    # puts "=================="
    # if body.include?("\u2024")
    #   puts "body"
    # elsif title.include?("\u2024")
    #   puts "title"
    # end
    # if quote && quote.include?("\u2024")
    #   puts "quote"
    # end
    if title && title != ""
      title.strip! 
      @head_line      = eliminate_size_option(title)
      @head_line      = @head_line.gsub("\r\n", "]]></HeadLine><HeadLine><![CDATA[")
    end
    if subtitle && subtitle != ""
      subtitle.strip! 
      @sub_head_line  = eliminate_size_option(subtitle)
      @sub_head_line  = @sub_head_line.gsub("\r\n", "]]></SubHeadLine><SubHeadLine><![CDATA[")
    end 
    if boxed_subtitle_text && boxed_subtitle_text != ""
      boxed_subtitle_text.strip!
      @boxed_subtitle = eliminate_size_option(boxed_subtitle_text)
    end

    # h = covert_to_multiple_line(title)
    # puts "++++++ h: #{h}"
    # if h.class == String
    #   @head_line1 = h
    # else
    #   puts "+++++++ title: #{title}"
    #   @head_line1 = h[0]
    #   @head_line2 = h[1]
    # end
    # sh = covert_to_multiple_line(subtitle)
    # if sh.class == String
    #   @sub_head_line1 = subtitle
    # else
    #   @sub_head_line1 = sh[0]
    #   @sub_head_line2 = sh[1]
    #   @sub_head_line3 = sh[2]
    # end
    @name_plate_code = category_code
    if page_number == 1
      @name_plate_code = category_code
      @sbject_ex = ""
    end
    @photo_item       = "#{@date_id}_#{@jeho_info}_#{@page_info}_#{two_digit_ord}.jpg"
    # if story_xml_template.include?("\u200B")
    #   binding.pry
    # end
    @page_number = page_number
    @order = order
    story_erb = ERB.new(story_xml_template)
    story_erb.result(binding)
    # story_erb = ERB.new(story_xml_template)
    # story_erb.result(binding)
  end

  def eliminate_size_option(string) # 제목/부제 사이즈 조절 {-3}같은 태그 제거 
    string = string.sub(/\{\s?(.?\d)\s?\}\s?$/, "") if string =~/\{\s?(.?\d)\s?\}\s?$/
    string = string.to_s
  end

  # def covert_to_multiple_line(string) # 2행만 가능. 3행일 경우 추가 필요
  #   s = string
  #   return "" unless s
  #   if string.include?("\r\n")
  #       s = string.split("\r\n")
  #       return s
  #   end
  #   s
  #  end

  # sample_title = "this a {-5}"
  # result = eliminate_size_option(sample_title)

  # a = "my string"

  def mobile_preview_xml_article_info
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    hour  = updated_at.hour.to_s.rjust(2, "0")
    min   = updated_at.min.to_s.rjust(2, "0")
    sec   = updated_at.sec.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    updated_date      = "#{year}#{month}#{day}"
    # if page.section_name = '오피니언'
    #   @news_title_info = '논설'
    # else
    #   @news_title_info  = page.section_name
    # end
      # reporter_record   = Reporter.where(name:reporter).first
      # if reporter_record
      #   @post             = reporter_record.reporter_group.name
      #   @gija_id          = email.split("@").first
      #   @email            = email
      # else
      #   @post             = "소속팀"
      #   @gija_id          = "기자아이디"
      #   @email            = "기자이메일"
      # end
    @name           = reporter
      # if reporter = nil || reporter = ""
      #   @name           = reporter_from_body
      # end
      # if @name =~/_/
      # @name = @name.split("_")[0]
      # end
    opinion_writer  = OpinionWriter.where(name:@name).first
    if opinion_writer
      @work        = opinion_writer.work if opinion_writer.work
      @position    = opinion_writer.position if opinion_writer.position
      @email       = opinion_writer.email if opinion_writer.email
      if @name =~/_/
        @name = @name.split("_")[0]
      end
      @by_line_body   = "<br><br>#{@name} #{@work} #{@position}"
      @by_line        = "#{@name} #{@work} #{@position}"
      @caption        = "#{@name} #{@work} #{@position}"
    end
    # reporter_record   = Reporter.where(name:reporter).first
    if page_number == 22 && order == 2
      profile         = Profile.where(name:@name).first
      if profile
        @work        = profile.work if profile.work
        @position       = profile.position if profile.position
        if @name =~/_/
          @name = @name.split("_")[0]
        end
        @by_line_body   = "<br><br>#{@name} #{@work} #{@position}"
        @by_line        = "#{@name} #{@work} #{@position}"
        @caption        = "#{@name} #{@work} #{@position}"
      end
    end
    if page_number == 23 && order == 2
      @name          = reporter_from_body
      @by_line       = reporter_from_body
      @caption       = reporter_from_body
    end
    if images.length > 0 
      @image          = images.first
      @caption        = ""
      @caption        = "#{@image.caption_title} | " if @image.caption_title && @image.caption_title != ""
      @caption        += "#{@image.caption} " if @image.caption && @image.caption != ""
      @caption        += "#{@image.source}" if @image.source && @image.source != ""
      @h_caption_title = @image.caption_title
      @h_caption       = @image.caption
      @h_source        = @image.source
    end
    @section_name_code = section_name_code
    if subject_head && subject_head != ""
      subject_head.strip! 
      @name_plate       = eliminate_size_option(subject_head)
    else
      # r = OpinionWriter.where(name: reporter).first
      # puts r
      if page_number == 22 || page_number == 23
        category_code = opinion_writer.category_code 
        @name_plate = opinion_writer.title
      end
    end    
    # unless @name_plate
    #   r = OpinionWriter.where(name:reporter).first
    #   puts r
    #   category_code = r.category_code
    #   @name_plate = "[#{r.title}]"
    # end
    @subject_ex_name  = @name_plate.gsub(/\[(.*)\]/){"#{$1}"} if @name_plate && @name_plate !="" 
    @money_status     = "30"
    if page_number == 22
      if kind == '사설'
        if subject_head == '기고'
          category_code = 2401
          @money_status = "0"
        elsif subject_head == '정치시평'
          category_code = 2201
        # elsif subject_head == '경제시평'
        #   category_code = 2202
        end
      end
    elsif page_number == 23
      if kind == '사설'
        category_code= 2101
      end
    end
    @subject_ex_code  = category_code
    @gisa_key         = "#{@date_id}991#{@page_info}#{two_digit_ord}"
    if title && title != ""
      title.strip! 
      @head_line        = eliminate_size_option(title)
      @head_line        = @head_line.gsub("\r\n", "]]></MainTitle><MainTitle><![CDATA[")
    end  
      # h = covert_to_multiple_line(@head_line)
    # if h.class == String
    #   @head_line1 = h
    # else
    #   @head_line1 = h[0]
    #   @head_line2 = h[1]
    # end
    if subtitle && subtitle != ""
      subtitle.strip! 
      @sub_head_line    = eliminate_size_option(subtitle)
      @sub_head_line    = @sub_head_line.gsub("\r\n", "]]></SubTitle><SubTitle><![CDATA[")
    end
    if boxed_subtitle_text && boxed_subtitle_text != ""
      boxed_subtitle_text.strip!
      @boxed_subtitle = eliminate_size_option(boxed_subtitle_text)
    end

    # sh = covert_to_multiple_line(@sub_head_line)
    #   if sh.class == String
    #     @sub_head_line1 = sh
    #   else
    #     @sub_head_line1 = sh[0]
    #     @sub_head_line2 = sh[1]
    #     @sub_head_line3 = sh[2]
    #   end
   if body && body != ""
      @body_content     = body.gsub(/^####(.*)\n/){"<!-- #{$1} -->"}
      @body_content     = @body_content.gsub(/^####(.*)\^\n/){"<!-- #{$1} -->"} 
      @body_content     = @body_content.gsub(/^##(.*)\n/){"<b style=font-weight:bold;>#{$1}</b><br>"} 
      @body_content     = @body_content.gsub(/^#\s(.*)/){"#{$1}"} 
      @body_content     = @body_content.gsub(/\^$/){""}
      @data_content     = @body_content.gsub("\n\n"){"<br><br>"} 
    end
    @page_number = page_number 
    @order = order.to_s.rjust(2, "0")
    @group_key        = "#{year}#{month}#{day}.011001#{page_info}0000#{@order}"
    @cms_file_name    = "#{year}#{month}#{day}00100#{page_info}#{@order}"
    @article_file_name = "#{year}#{month}#{day}011001#{page_info}0000000#{@order}"
    @gija_name        = "편집기자명" # 편집기자명
    @news_class_large_id    = news_class_large_id
    @news_class_large_name  = page.section_name
    @news_class_middle_id   = category_code
    @news_class_middle_name = subject_head
    @send_modify            = "0"  # 수정횟수
    @new_article            = "1" #뭘까?
    @photo_file_name        = "#{year}#{month}#{day}.011001#{page_info}0000#{@order}.01L.jpg"
    #해당기사 저자사진: 121 × 160 픽셀, 120 픽셀/인치
    #해당기사 그래픽은 .01L대신 .01S.jpg로 표시
article_info =<<EOF
    <ArticleInfo>
      <GroupKey><%= @group_key %></GroupKey>
      <CmsFileName><%= @cms_file_name %></CmsFileName>
      <CmsRelationName/>
      <ArticleFileName><%= @article_file_name %>.txt</ArticleFileName>
      <GisaNumberID/>
      <GisaRelationID/>
      <ByLine/>
      <Gija ID="0" Area="0" Name="<%= @gija_name %>" Email=""/>
      <NewsClass LargeID="<%= @news_class_large_id %>" LargeName="<%= @news_class_large_name %>" MiddleID="<%= @news_class_middle_id %>" MiddleName="<%= @news_class_middle_name %>"/>
      <SendModify><%= @send_modify %></SendModify>
      <NewArticle><%= @new_article %></NewArticle>
    </ArticleInfo>
EOF
    article = ""
    erb = ERB.new(article_info)
    article += erb.result(binding)
  end

  def mobile_preview_xml_three_component
    if page_number == 22
      three_component =<<EOF
      <TitleComponent><!-- 22면 -->
        <MainTitle><![CDATA[<%= [@name_plate] %> <%= @head_line %>]]></MainTitle>
      </TitleComponent>
      <ArticleComponent>
        <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %><%= @by_line_body %>]]></Content>
      </ArticleComponent>
      <PhotoComponent>
      <PhotoItem>
        <ImageType>Image</ImageType>
          <Property ImgClass="[IMG01]" align="left" Class="일반" Size="Large"/>
          <PhotoFileName><%= @photo_file_name %></PhotoFileName>
          <DataContent><![CDATA[ <%= @caption %>]]></DataContent>
        </PhotoItem>
      </PhotoComponent>
    </Article>
EOF

    elsif page_number == 23 && order == 1 
    three_component =<<EOF
    <TitleComponent><!-- 23면 1 -->
      <MainTitle><![CDATA[<%= [@name_plate] %> <%= @head_line %>]]></MainTitle>
    </TitleComponent>
    <ArticleComponent>
      <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %><%= @by_line_body %>]]></Content>
    </ArticleComponent>
    <PhotoComponent>
    <PhotoItem>
      <ImageType>Image</ImageType>
        <Property ImgClass="[IMG01]" align="left" Class="일반" Size="Large"/>
        <PhotoFileName><%= @photo_file_name %></PhotoFileName>
        <DataContent><![CDATA[ <%= @caption %>]]></DataContent>
      </PhotoItem>
    </PhotoComponent>
  </Article>
EOF
  elsif page_number == 23 && order == 2 
  three_component =<<EOF
  <TitleComponent><!-- 23면 2 -->
    <MainTitle><![CDATA[<%= [@name_plate] %> <%= @head_line %>]]></MainTitle><% if page_number == 23 && order == 2 %><% else %><% if @sub_head_line == nil && @sub_head_line == "" %><% else %>
    <SubTitle><![CDATA[<%= @sub_head_line %>]]></SubTitle><% end %><% end %>
  </TitleComponent>
  <ArticleComponent>
    <Content><![CDATA[<%= @data_content %>]]></Content>
  </ArticleComponent>
</Article>
EOF

elsif page_number == 23 && order == 3
  three_component =<<EOF
  <TitleComponent><!-- 23면 3 -->
    <MainTitle><![CDATA[<%= [@name_plate] %> <%= @head_line %>]]></MainTitle>
  </TitleComponent>
  <ArticleComponent>
    <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %><%= @by_line_body %>]]></Content>
  </ArticleComponent>
  <PhotoComponent>
  <PhotoItem>
    <ImageType>Image</ImageType>
      <Property ImgClass="[IMG01]" align="left" Class="일반" Size="Large"/>
      <PhotoFileName><%= @photo_file_name %></PhotoFileName>
      <DataContent><![CDATA[ <%= @caption %>]]></DataContent>
    </PhotoItem>
  </PhotoComponent>
</Article>
EOF

  elsif kind == "사진"
  three_component =<<EOF
  <TitleComponent><!-- photobox -->
  <MainTitle><![CDATA[<%= "[#{@name_plate}] " if @name_plate && @name_plate !="" %><%= "| #{@boxed_subtitle} | " if @boxed_subtitle && @boxed_subtitle != "" %><%= @h_caption_title %>]]></MainTitle><% if @sub_head_line == nil && @sub_head_line == "" %><% else %>
  <SubTitle><![CDATA[<%= @sub_head_line %>]]></SubTitle><% end %>
</TitleComponent>
<ArticleComponent>
  <Content><![CDATA[<!--[[--image1--]]//--><%= @h_caption %> <%= @h_source %>]]>
  </Content>
</ArticleComponent><% if images.length < 0 || graphics.length < 0 %><% else %>
<PhotoComponent>
  <PhotoItem>
  <ImageType>Image</ImageType> 
    <Property ImgClass="[IMG01]" align="center" Class="일반" Size="Large"/>
      <PhotoFileName><%= @photo_file_name %></PhotoFileName>
  </PhotoItem>
</PhotoComponent><% end %>
</Article>
EOF

  elsif images.count > 0 
  three_component =<<EOF
  <TitleComponent><!-- images -->
    <MainTitle><![CDATA[<%= "[#{@name_plate}] " if @name_plate && @name_plate !="" %><%= "| #{@boxed_subtitle} | " if @boxed_subtitle && @boxed_subtitle != "" %><%= @head_line %>]]></MainTitle><% if @sub_head_line == nil && @sub_head_line == "" %><% else %>
    <SubTitle><![CDATA[<%= @sub_head_line %>]]></SubTitle><% end %>
  </TitleComponent>
  <ArticleComponent>
    <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %> <%= @by_line_body %>]]>
    </Content>
  </ArticleComponent><% if images.length < 0 || graphics.length < 0 %><% else %>
  <PhotoComponent>
    <PhotoItem>
    <ImageType>Image</ImageType> 
      <Property ImgClass="[IMG01]" align="center" Class="일반" Size="Large"/>
        <PhotoFileName><%= @photo_file_name %></PhotoFileName>
        <DataContent><![CDATA[ <%= @caption %>]]></DataContent>
    </PhotoItem>
  </PhotoComponent><% end %>
</Article>
EOF

  elsif graphics.count > 0 
  three_component =<<EOF
  <TitleComponent><!-- graphic -->
    <MainTitle><![CDATA[<%= "[#{@name_plate}] " if @name_plate && @name_plate !="" %><%= "| #{@boxed_subtitle} | " if @boxed_subtitle && @boxed_subtitle != "" %><%= @head_line %>]]></MainTitle><% if @sub_head_line == nil && @sub_head_line == "" %><% else %>
    <SubTitle><![CDATA[<%= @sub_head_line %>]]></SubTitle><% end %>
  </TitleComponent>
  <ArticleComponent>
    <Content><![CDATA[<!--[[--image1--]]//--><%= @data_content %> <%= @by_line_body %>]]>
    </Content>
  </ArticleComponent><% if images.length < 0 || graphics.length < 0 %><% else %>
  <PhotoComponent>
    <PhotoItem>
    <ImageType>Image</ImageType> 
      <Property ImgClass="[IMG01]" align="center" Class="일반" Size="Large"/>
        <PhotoFileName><%= @photo_file_name %></PhotoFileName>
        <DataContent><![CDATA[ <%= @caption %>]]></DataContent>
    </PhotoItem>
  </PhotoComponent><% end %>
</Article>
EOF


  else
  three_component =<<EOF
  <TitleComponent><!-- etc -->
    <MainTitle><![CDATA[<%= "[#{@name_plate}] " if @name_plate && @name_plate !="" %><%= "| #{@boxed_subtitle} | " if @boxed_subtitle && @boxed_subtitle != "" %><%= @head_line %>]]></MainTitle><% if @sub_head_line == nil && @sub_head_line == "" %><% else %>
    <SubTitle><![CDATA[<%= @sub_head_line %>]]></SubTitle><% end %>
  </TitleComponent>
  <ArticleComponent>
    <Content><![CDATA[<%= @data_content %> <%= @by_line_body %>]]></Content>
  </ArticleComponent>
</Article>
EOF

  end
  component = ""

  erb = ERB.new(three_component)
  component += erb.result(binding)
  end

  def xml_group_key_template
    @name_plate       = subject_head
    unless @name_plate
      r = OpinionWriter.where(name:reporter).first
      puts r
      category_code = r.category_code
      @name_plate = r.title
    end
    year  = issue.date.year
    month = issue.date.month.to_s.rjust(2, "0")
    day   = issue.date.day.to_s.rjust(2, "0")
    page_info        = page_number.to_s.rjust(2,"0")
    @head_line        = title    
    # if title && title != ""
    #   title.strip!
    #   @head_line        = title    
    #   @head_line        = @head_line.gsub("\u201C", "&quot;")
    #   @head_line        = @head_line.gsub("\u201D", "&quot;")
    #   @head_line        = @head_line.gsub("\u0022", "&quot;")
    #   @head_line        = @head_line.gsub("\u003C", "&lt;")
    #   @head_line        = @head_line.gsub("\u003E", "&gt;")
    # end
    @order            = order.to_s.rjust(2, "0")
    @group_key        = "#{year}#{month}#{day}.011001#{page_info}0000#{@order}"
    if title && title != ""
      @c_head_line    = eliminate_size_option(title)
    else 
      @c_head_line    = @h_caption_title    
    end
    container_xml_group_key=<<EOF
      <Group Key="<%= @group_key %>" CmsFileName="" Title="<%= "[#{@name_plate}] " if @name_plate && @name_plate !="" %><%= @c_head_line %>"/>
EOF
    xml_group_key = ""
    erb = ERB.new(container_xml_group_key)
    xml_group_key += erb.result(binding)
  end

  def mobile_page_preview_path
    "#{Rails.root}/public/1/issue/#{issue.date.to_s}/mobile_page_preview/1001#{page_number.to_s.rjust(2,"0")}"
  end

  def save_mobile_xml_image
    source = image_source
    return if source.nil?
    target = mobile_page_preview_path + "/#{@photo_file_name}"
    system("cp #{source} #{target}")
    if images.length > 0
      file_name = "#{page_number}_#{order}_#{images.length-1}.*"  # images.length 가 아닌 현재 파일 오더?를 가져올 수 있어야할텐데...
      # system("cd #{issue.path}/images/ && convert #{file_name} -resize 620 #{mobile_page_preview_path}/#{@photo_file_name}")
      system("cd #{issue.path}/images/ && sips -s format jpeg -s formatOptions best -Z 1200 #{file_name} --out #{mobile_page_preview_path}/#{@photo_file_name}")
      # return issue.path + "/images/#{photo_file_name}"
      return ""
    else graphics.length > 0
      # binding.pry
      file_name = "graphic_#{page_number}_#{order}_#{graphics.length-1}.pdf" # images.length 가 아닌 현재 파일 오더?를 가져올 수 있어야할텐데...
      system("cd #{issue.path}/images/ && convert -density 300 -resize 1200 #{file_name} #{mobile_page_preview_path}/#{@photo_file_name}")
      # system("cd #{issue.path}/images/ && sips -s format jpeg -s formatOptions best -Z 1200 #{file_name} --out #{mobile_page_preview_path}/#{@photo_file_name}")
      # return issue.path + "/images/#{graphic_file_name}"
      return ""
    end
  end
end