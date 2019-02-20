class YhArticlesController < ApplicationController
  before_action :set_yh_article, only: [:show, :edit, :update, :destroy]

  # GET /yh_articles
  # GET /yh_articles.json
  def index
    @yh_articles = YhArticle.all
  end

  # GET /yh_articles/1
  # GET /yh_articles/1.json
  def show
  end

  # GET /yh_articles/new
  def new
    @yh_article = YhArticle.new
  end

  # GET /yh_articles/1/edit
  def edit
  end

  # POST /yh_articles
  # POST /yh_articles.json
  def create
    @yh_article = YhArticle.new(yh_article_params)

    respond_to do |format|
      if @yh_article.save
        format.html { redirect_to @yh_article, notice: 'Yh article was successfully created.' }
        format.json { render :show, status: :created, location: @yh_article }
      else
        format.html { render :new }
        format.json { render json: @yh_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /yh_articles/1
  # PATCH/PUT /yh_articles/1.json
  def update
    respond_to do |format|
      if @yh_article.update(yh_article_params)
        format.html { redirect_to @yh_article, notice: 'Yh article was successfully updated.' }
        format.json { render :show, status: :ok, location: @yh_article }
      else
        format.html { render :edit }
        format.json { render json: @yh_article.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /yh_articles/1
  # DELETE /yh_articles/1.json
  def destroy
    @yh_article.destroy
    respond_to do |format|
      format.html { redirect_to yh_articles_url, notice: 'Yh article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_yh_article
      @yh_article = YhArticle.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def yh_article_params
      params.require(:yh_article).permit(:action, :service_type, :content_id, :date, :time, :urgency, :category, :class_code, :attriubute_code, :source, :credit, :region, :title, :body, :writer, :char_count, :taken_by)
    end
end
