class WorkingArticlesController < ApplicationController
  before_action :set_working_article, only: [:show, :edit, :update, :destroy, :download_pdf, :to_markdown_para, :upload_images, :zoom_preview, :assign_reporter, :add_image]
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
  end

  # GET /working_articles/new
  def new
    @working_article = WorkingArticle.new
  end

  # GET /working_articles/1/edit
  def edit
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
      # if filter_markdown?
      params['working_article']['body'] = @working_article.filter_to_markdown(params['working_article']['body'])
      # end
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
  # download story.pdf
  def download_pdf
    send_file @working_article.pdf_path, :type=>'application/pdf', :x_sendfile=>true, :disposition => "attachment"
  end

  def to_markdown_para
    @working_article.to_markdown_para
    redirect_to working_article_path(@working_article)
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

  def assign_reporter
    @working_article.update(working_article_params)
    redirect_to assign_reporter_issue_path(Issue.last)
  end

  def extend_zero
    set_working_article
    @working_article.extend_line(0)
    redirect_to working_article_path(@working_article) , notice: '박스크기 0 행 추가로 설정 되었습니다.'
  end

  def extend_one
    set_working_article
    @working_article.extend_line(1)
    redirect_to working_article_path(@working_article), notice: '박스크기 1 행 추가로 설정 되었습니다.'
  end

  def extend_two
    set_working_article
    @working_article.extend_line(2)
    redirect_to working_article_path(@working_article), notice: '박스크기 2 행 추가로 설정 되었습니다.'
  end

  def extend_three
    set_working_article
    @working_article.extend_line(3)
    redirect_to working_article_path(@working_article), notice: '박스크기 3 행 추가로 설정 되었습니다.'
  end

  def extend_four
    set_working_article
    @working_article.extend_line(4)
    redirect_to working_article_path(@working_article), notice: '박스크기 4 행 추가로 설정 되었습니다.'
  end

  def reduce_one
    set_working_article
    @working_article.extend_line(-1)
    redirect_to working_article_path(@working_article), notice: '박스크기 -1 행 축소 설정 되었습니다.'
  end

  def reduce_two
    set_working_article
    @working_article.extend_line(-2)
    redirect_to working_article_path(@working_article), notice: '박스크기 -2 행 축소 설정 되었습니다.'
  end

  def reduce_three
    set_working_article
    @working_article.extend_line(-3)
    redirect_to working_article_path(@working_article), notice: '박스크기 -3 행 축소 설정 되었습니다.'
  end

  def reduce_four
    set_working_article
    @working_article.extend_line(-4)
    redirect_to working_article_path(@working_article), notice: '박스크기 -4 행 축소 설정 되었습니다.'
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


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_working_article
      @working_article = WorkingArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def working_article_params
      params.require(:working_article).permit(:column, :row, :order, :profile, :kind, :subject_head, :title,  :title_head, :subtitle, :body, :reporter, :email, :personal_image, :image, :quote, :is_front_page, :top_story, :top_position, :page_id)
    end

    def filter_markdown?
      params[:commit] == "본문정리"
    end
end
