class WorkingArticlesController < ApplicationController
  before_action :set_working_article, only: [:show, :edit, :update, :destroy, :download_pdf, :upload_images, :zoom_preview,:change_story, :update_story, :assign_reporter, :add_image]
  layout 'working_article'
  # GET /working_articles
  # GET /working_articles.json
  def index
    # rails controller 에서
    # ruby 에서 아뭬데나
    @working_articles = WorkingArticle.all
  end

  # GET /working_articles/1
  # GET /working_articles/1.json
  def show
    respond_to do |format|
      format.html
      format.json { render @working_article}
    end
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

      if @working_article.update(working_article_params)
        @working_article.generate_pdf_with_time_stamp
        @working_article.page.generate_pdf_with_time_stamp
        # format.html { rendrer @working_article, notice: 'Working article was successfully updated.' }
        # format.html { redirect_to @working_article, notice: 'Working article was successfully updated.' }
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
    # @stories = Story.where(group: , date: date)
    @stories = Story.where(group: @working_article.page.section_name)
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
        redirect_to eigth_group_stories_issue_path(@working_article.issue)
      when 'nineth_group'
        redirect_to nineth_group_stories_issue_path(@working_article.issue)
      end

        # if @working_article.update(working_article_params)

      #   # format.html { rendrer @working_article, notice: 'Working article was successfully updated.' }
      #   # format.html { redirect_to @working_article, notice: 'Working article was successfully updated.' }
      #   format.js {render :js => "window.location = '#{working_article_path(@working_article)}'"}
      #   format.json { render :show, status: :ok, location: @working_article }
      # else
      #   format.html { render :edit }
      #   format.json { render json: @working_article.errors, status: :unprocessable_entity }
      # end
    
  end

  # download story.pdf
  def download_pdf
    send_file @working_article.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"
  end

  def image_1x1
    image = @working_article.images.first
    image.change_size("1x1")
  end

  def image_2x2
    image.change_size("2x2")
  end

  def image_3x3
    image.change_size("3x3")
  end

  def image_4x4
    image.change_size("4x4")
  end

  def image_5x5
    image.change_size("5x5")
  end

  def image_auto
    image.change_size("auto")
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

  def upload_images
    respond_to do |format|
      format.html do
         params[:images]['image'].each do |a|
           @image = @working_article.images.create!(:image => a, :working_article_id => @working_article.id)
         end
       end
     end
    redirect_to @working_article
    # images_issue_path(Issue.last.id)
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

  def quote_auto
    set_working_article
    @working_article.quote_auto
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
      @working_article = WorkingArticle.includes(:page).friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def working_article_params
      params.require(:working_article).permit(:column, :row, :order, :profile, :kind, :subject_head, :title,  :title_head, :subtitle, :body, :reporter, :email, :has_profile_image, :image, :quote, :is_front_page, :top_story, :top_position, :page_id)
    end

    def filter_markdown?
      params[:commit] == "본문정리"
    end
end
