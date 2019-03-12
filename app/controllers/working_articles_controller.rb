class WorkingArticlesController < ApplicationController
  before_action :set_working_article, only: [:show, :edit, :update, :destroy, :download_pdf, :upload_images, :upload_graphics, :zoom_preview,:change_story, :update_story, :assign_reporter, :add_image]
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  layout 'working_article'
  # GET /working_articles
  # GET /working_articles.json
  def index
    # rails controller 에서
    # ruby 
    @q = WorkingArticle.ransack(params[:q])
    @working_articles = @q.result
    # @pages = Page.all.includes(:issue)
    # @working_articles = WorkingArticle.all
  end

  # GET /working_articles/1
  # GET /working_articles/1.json
  def show
    @pages = @working_article.issue.pages.order(:id, 'desc')
    section_name = @working_article.page.section_name
    @pages = @working_article.issue.pages.select {|p| p.section_name == section_name}
    respond_to do |format|
      format.html
      format.json {render @working_article}
    end
    change_story
  end

  # GET /working_articles/new
  def new
    @working_article = WorkingArticle.new
  end

  # GET /working_articles/1/edit 
  def edit
    puts "in edit of working_article"
    puts "@working_article.issue.date:#{@working_article.issue.date}"
    puts "@working_article.page.section_name:#{@working_article.page.section_name}"
    # @stories = Story.where(date:@working_article.date, group: @working_article.page.section_name)
    @stories = Story.where(group: @working_article.page.section_name)
  end

  # POST /working_articles
  # POST /working_articles.json
  def create
    @working_article = WorkingArticle.new(working_article_params)

    respond_to do |format|
      if @working_article.save
        format.html { redirect_to @working_article, notice: 'Working article was successfully created.' }
        format.json { render :show, status: :created, location: @working_article }
      else
        format.html { render :new }
        format.json { render json: @working_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /working_articles/1
  # PATCH/PUT /working_articles/1.json
  def update
    respond_to do |format|
      params['working_article']['title'] = @working_article.filter_to_title(params['working_article']['title'])
      params['working_article']['subtitle'] = @working_article.filter_to_title(params['working_article']['subtitle'])
      params['working_article']['body'] = @working_article.filter_to_markdown(params['working_article']['body'])
      if @working_article.update(working_article_params)
        @working_article.generate_pdf_with_time_stamp
        @working_article.page.generate_pdf_with_time_stamp
        # format.html { render @working_article, notice: 'Working article was successfully updated.' }
        format.html { redirect_to @working_article, notice: 'Working article was successfully updated.' }
        format.js {render :js => "window.location = '#{working_article_path(@working_article)}'"}
        format.json { render :show, status: :ok, location: @working_article }
      else
        format.html { render :edit }
        format.json { render json: @working_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /working_articles/1
  # DELETE /working_articles/1.json
  def destroy
    @working_article.destroy
    respond_to do |format|
      format.html { redirect_to working_articles_url, notice: 'Working article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign_reporter
    # @working_article.update(working_article_params)

    respond_to do |format|
      if @working_article.update(working_article_params)

        # format.html { rendrer @working_article, notice: 'Working article was successfully updated.' }
        # format.html { redirect_to @working_article, notice: 'Working article was successfully updated.' }
        format.js {render :js => "window.location = '#{working_article_path(@working_article)}'"}
        format.json { render :show, status: :ok, location: @working_article }
      else
        format.html { render :edit }
        format.json { render json: @working_article.errors, status: :unprocessable_entity }
      end
    end
    # redirect_to assign_reporter_issue_path(Issue.last)
  end

  def change_story
    #todo
    # @stories = Story.where(group: , date: date) name: :desc
    @stories = Story.where(summitted_section: @working_article.page.section_name).order(selected: 'asc')
    assigned = @stories.select{|s| s.working_article_id == @working_article.id}
    if assigned.length > 0
      @stories = assigned
    end
    #TODO
    # if story is assigned, to current_article, no need to display other stories

  end

  def update_story
      story_id = params[:story_id]
      # update working_article with new story
      case session[:current_story_group]
      when 'first_group'
        redirect_to first_group_stories_issue_path(@working_article.issue)
      when 'second_group'
        redirect_to second_group_stories_issue_path(@working_article.issue)
      when 'third_group'
        redirect_to third_group_stories_issue_path(@working_article.issue)
      when 'fourth_group'
        redirect_to fourth_group_stories_issue_path(@working_article.issue)
      when 'fifth_group'
        redirect_to fifth_group_stories_issue_path(@working_article.issue)
      when 'sixth_group'
        redirect_to sixth_group_stories_issue_path(@working_article.issue)
      when 'seventh_group'
        redirect_to seventh_group_stories_issue_path(@working_article.issue)
      when 'seventh_group'
        redirect_to seventh_group_stories_issue_path(@working_article.issue)
      when 'eighth_group'
        redirect_to eighth_group_stories_issue_path(@working_article.issue)
      when 'nineth_group'
        redirect_to nineth_group_stories_issue_path(@working_article.issue)
      end    
  end

  def first_group
    set_issue
    group = @working_article.issue.publication.sections[0]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}
    session[:current_group] = 'first_group'
  end

  def second_group
    set_issue
    group = @working_article.issue.publication.sections[1]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}
    session[:current_group] = 'second_group'
  end

  def third_group
    set_issue
    group = @working_article.issue.publication.sections[2]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}    
    session[:current_group] = 'third_group'
  end

  def fourth_group
    set_issue
    group = @working_article.issue.publication.sections[3]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}    
    session[:current_group] = 'fourth_group'
  end

  def fifth_group
    set_issue
    group = @working_article.issue.publication.sections[4]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}  
    session[:current_group] = 'fifth_group'
  end

  def sixth_group
    set_issue
    group = @working_article.issue.publication.sections[5]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}  
    session[:current_group] = 'sixth_group'
  end

  def seventh_group
    set_issue
    group = @working_article.issue.publication.sections[6]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}  
    session[:current_group] = 'seventh_group'
  end

  def eighth_group
    set_issue
    group = @working_article.issue.publication.sections[7]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}  
    session[:current_group] = 'eighth_group'
  end

  # 오피니언
  def nineth_group
    set_issue
    group = @working_article.issue.publication.sections[8]
    @pages = @working_article.issue.pages.select{|p| p.section_name == group}  
    session[:current_group] = 'nineth_group'
  end

  def ad_group
    set_issue
    session[:current_group] = 'ad_group'
    @pages = @working_article.issue.pages.select{|p| p.section_name == '전면광고'}
  end

  # download story.pdf
  def download_pdf
    send_file @working_article.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"
  end

  def image_1x1
    set_working_article
    image = @working_article.images.first
    if image
      need_pdf_update = image.change_size("1x1")
    else
      need_pdf_update = @working_article.create_image_place_holder(1,1)
    end
    @working_article.generate_pdf_with_time_stamp if need_pdf_update
    redirect_to @working_article
  end

  def image_2x2
    set_working_article
    image = @working_article.images.first
    if image
      need_pdf_update = image.change_size("2x2")
    else
      need_pdf_update = @working_article.create_image_place_holder(2,2)
    end
    @working_article.generate_pdf_with_time_stamp if need_pdf_update
    redirect_to @working_article
  end

  def image_3x3
    set_working_article
    image = @working_article.images.first
    if image
      need_pdf_update = image.change_size("3x3")
    else
      need_pdf_update = @working_article.create_image_place_holder(3,3)
    end
    @working_article.generate_pdf_with_time_stamp if need_pdf_update    
    redirect_to @working_article
  end

  def image_4x4
    set_working_article
    image = @working_article.images.first
    if image
      need_pdf_update = image.change_size("4x4")
    else
      need_pdf_update = @working_article.create_image_place_holder(4,4)
    end
    @working_article.generate_pdf_with_time_stamp if need_pdf_update    
    redirect_to @working_article
  end

  def image_5x5
    set_working_article
    image = @working_article.images.first
    if image
      need_pdf_update = image.change_size("5x5")
    else
      need_pdf_update = @working_article.create_image_place_holder(5,5)
    end
    @working_article.generate_pdf_with_time_stamp if need_pdf_update    
    redirect_to @working_article
  end

  def image_auto
    set_working_article
    image = @working_article.images.first
    image.change_size("auto")
    redirect_to @working_article
  end

  def add_image
    @library_images = @working_article.library_images
    @current_image  = images.first
  end

  def select_image
    images.first
    @selected_image = params[:selected_image]
  end


  def add_personal_image
    #code
  end

  def add_empty_image

  end

  def upload_images
    respond_to do |format|
      format.html do
        if  params[:images]
          params[:images]['image'].each do |a|
            @image = @working_article.images.create!(:image => a, :working_article_id => @working_article.id)
          end
        else
          @image = @working_article.images.create!(:working_article_id => @working_article.id)
        end
       end
     end
    @image.working_article.generate_pdf_with_time_stamp
    @image.working_article.page.generate_pdf_with_time_stamp
    redirect_to @working_article
    # images_issue_path(Issue.last.id)
  end

  def upload_graphics
    respond_to do |format|
      format.html do
         params[:images]['image'].each do |a|
           @graphic = @working_article.graphics.create!(:graphic => a, :working_article_id => @working_article.id)
         end
       end
     end
    @graphic.working_article.generate_pdf_with_time_stamp
    @graphic.working_article.page.generate_pdf_with_time_stamp
    redirect_to @working_article
  end

  def zoom_preview
    #code
  end

  def extend_zero
    set_working_article
    @working_article.set_extend_line(0)
    redirect_to working_article_path(@working_article) , notice: '박스크기 추가가 0행으로 설정 되었습니다.'
  end

  def extend_one
    set_working_article
    @working_article.extend_line(1)
    redirect_to working_article_path(@working_article), notice: '박스크기 1 행 추가 되었습니다.'
  end

  def extend_two
    set_working_article
    @working_article.extend_line(2)
    redirect_to working_article_path(@working_article), notice: '박스크기 2 행 추가 되었습니다.'
  end

  def extend_three
    set_working_article
    @working_article.extend_line(3)
    redirect_to working_article_path(@working_article), notice: '박스크기 3 행 추가 되었습니다.'
  end

  def extend_four
    set_working_article
    @working_article.extend_line(4)
    redirect_to working_article_path(@working_article), notice: '박스크기 4 행 추가 되었습니다.'
  end

  def reduce_one
    set_working_article
    @working_article.extend_line(-1)
    redirect_to working_article_path(@working_article), notice: '박스크기 -1 행 축소 되었습니다.'
  end

  def reduce_two
    set_working_article
    @working_article.extend_line(-2)
    redirect_to working_article_path(@working_article), notice: '박스크기 -2 행 축소 되었습니다.'
  end

  def reduce_three
    set_working_article
    @working_article.extend_line(-3)
    redirect_to working_article_path(@working_article), notice: '박스크기 -3 행 축소 되었습니다.'
  end

  def reduce_four
    set_working_article
    @working_article.extend_line(-4)
    redirect_to working_article_path(@working_article), notice: '박스크기 -4 행 축소 되었습니다.'
  end

  def swap
    set_working_article
    @working_article.swap
    redirect_to working_article_path(@working_article), notice: '위 아래 가사가 교체 되었습니다.'
  end

  def swap_with_one
    set_working_article
    @working_article.swap_with(1)
    redirect_to working_article_path(@working_article), notice: '위 아래 가사가 교체 되었습니다.'
  end

  def swap_with_two
    set_working_article
    @working_article.swap_with(2)
    redirect_to working_article_path(@working_article), notice: '2번 가사와 교체 되었습니다.'
  end

  def swap_with_three
    set_working_article
    @working_article.swap_with(3)
    redirect_to working_article_path(@working_article), notice: '3번 가사와 교체 되었습니다.'
  end

  def swap_with_four
    set_working_article
    @working_article.swap_with(4)
    redirect_to working_article_path(@working_article), notice: '4번 가사와 교체 되었습니다.'
  end

  def swap_with_five
    set_working_article
    @working_article.swap_with(5)
    redirect_to working_article_path(@working_article), notice: '5번 가사와 교체 되었습니다.'
  end

  def swap_with_six
    set_working_article
    @working_article.swap_with(6)
    redirect_to working_article_path(@working_article), notice: '6번 가사와 교체 되었습니다.'
  end

  def swap_with_seven
    set_working_article
    @working_article.swap_with(7)
    redirect_to working_article_path(@working_article), notice: '7번 가사와 교체 되었습니다.'
  end

  def swap_with_eight
    set_working_article
    @working_article.swap_with(8)
    redirect_to working_article_path(@working_article), notice: '8번 가사와 교체 되었습니다.'
  end

  def swap_with_nine
    set_working_article
    @working_article.swap_with(9)
    redirect_to working_article_path(@working_article), notice: '9번 가사와 교체 되었습니다.'
  end

  def swap_with_ten
    set_working_article
    @working_article.swap_with(10)
    redirect_to working_article_path(@working_article), notice: '10번 가사와 교체 되었습니다.'
  end

  def swap_with_eleven
    set_working_article
    @working_article.swap_with(11)
    redirect_to working_article_path(@working_article), notice: '11번 가사와 교체 되었습니다.'
  end

  def swap_with_twelve
    set_working_article
    @working_article.swap_with(12)
    redirect_to working_article_path(@working_article), notice: '12번 가사와 교체 되었습니다.'
  end

  def swap_with_thirteen
    set_working_article
    @working_article.swap_with(13)
    redirect_to working_article_path(@working_article), notice: '13번 가사와 교체 되었습니다.'
  end

  def swap_with_fourteen
    set_working_article
    @working_article.swap_with(14)
    redirect_to working_article_path(@working_article), notice: '14번 가사와 교체 되었습니다.'
  end

  # def quote_auto
  #   set_working_article
  #   @working_article.quote_auto
  #   redirect_to working_article_path(@working_article), notice: '발문 박스 자동크기 설정 되었습니다.'
  # end

  def quote_default
    set_working_article
    @working_article.quote_line(4)
    redirect_to working_article_path(@working_article), notice: '발문 박스 자동크기 설정 되었습니다.'
  end

  def quote_zero
    set_working_article
    @working_article.quote_line(0)
    redirect_to working_article_path(@working_article), notice: '발문 박스가 삭제 되었습니다.'
  end

  def quote_one
    set_working_article
    @working_article.quote_line(1)
    redirect_to working_article_path(@working_article), notice: '1 행용 발문 박스(6줄 추가됨) 설정 되었습니다.'
  end

  def quote_two
    set_working_article
    @working_article.quote_line(2)
    redirect_to working_article_path(@working_article), notice: '2 행용 발문 박스(8줄 추가) 설정 되었습니다.'
  end

  def quote_three
    set_working_article
    @working_article.quote_line(3)
    redirect_to working_article_path(@working_article), notice: '3 행용 발문 박스(10줄 추가) 설정 되었습니다.'
  end

  def quote_four
    set_working_article
    @working_article.quote_line(4)
    redirect_to working_article_path(@working_article), notice: '4 행용 발문 박스(12줄 추가) 설정 되었습니다.'
  end

  def boxed_subtitle_one
    set_working_article
    @working_article.boxed_subtitle_one
    redirect_to working_article_path(@working_article), notice: '본문 박스부제가(회색_고딕)가 생성 되었습니다.'
  end
  
  def boxed_subtitle_two
    set_working_article
    @working_article.boxed_subtitle_two
    redirect_to working_article_path(@working_article), notice: '본문 박스부제가(테두리)가 생성 되었습니다.'

  end

  def boxed_subtitle_zero
    set_working_article
    @working_article.boxed_subtitle_zero
    redirect_to working_article_path(@working_article), notice: '본문 박스부제가 삭제 되었습니다.'
  end

  def announcement_zero
    set_working_article
    @working_article.announcement_zero
    redirect_to working_article_path(@working_article), notice: '1단(내일 쉽니다.) 안내문이 생성 되었습니다.'
  end

  def announcement_one
    set_working_article
    @working_article.announcement_one
    redirect_to working_article_path(@working_article), notice: '1단(내일 쉽니다.) 안내문이 생성 되었습니다.'
  end

  def announcement_two
    set_working_article
    @working_article.announcement_two
    redirect_to working_article_path(@working_article), notice: '2단(다음면으로...) 안내문이 생성 되었습니다.'
  end

  def split_article(options)
    @working_article.split(options)
  end

  def split_article_vertically(options)
    split_article(direction:'v')
  end

  def split_article_horinotally(options)
    split_article(direction:'h')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_working_article
      # @working_article = WorkingArticle.find(params[:id])
      @working_article = WorkingArticle.includes(:page).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def working_article_params
      params.require(:working_article).permit(:column, :row, :order, :profile, :kind, :subject_head, :title, :heading_columns, :title_head, :subtitle, :subtitle_type, :subtitle_head, :body, :reporter, :email, :has_profile_image, :image, :quote, :is_front_page, :top_story, :top_position, :page_id, :boxed_subtitle_type, :boxed_subtitle_text, :announcement_text, :announcement_color, :quote_position, :quote_x_grid, :quote_v_extra_space, :quote_alignment, :quote_line_type)
    end

    def filter_markdown?
      params[:commit] == "본문정리"
    end
end
