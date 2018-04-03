class WorkingArticlesController < ApplicationController
  before_action :set_working_article, only: [:show, :edit, :update, :destroy, :download_pdf, :upload_images, :zoom_preview, :assign_reporter]

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
      # binding.pry

      if @working_article.update(working_article_params)
        @working_article.generate_pdf
        @working_article.update_page_pdf
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

  def add_quote
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_working_article
      @working_article = WorkingArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def working_article_params
      params.require(:working_article).permit(:column, :row, :order, :profile, :kind, :subject_head, :title,  :title_head, :subtitle, :body, :reporter, :email, :personal_image, :image, :quote, :is_front_page, :top_story, :top_position, :page_id)
    end
end
