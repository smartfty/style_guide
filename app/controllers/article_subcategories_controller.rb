class ArticleSubcategoriesController < ApplicationController
  before_action :set_article_subcategory, only: [:show, :edit, :update, :destroy]

  # GET /article_subcategories
  # GET /article_subcategories.json
  def index
    @article_subcategories = ArticleSubcategory.all
  end

  # GET /article_subcategories/1
  # GET /article_subcategories/1.json
  def show
  end

  # GET /article_subcategories/new
  def new
    @article_subcategory = ArticleSubcategory.new
  end

  # GET /article_subcategories/1/edit
  def edit
  end

  # POST /article_subcategories
  # POST /article_subcategories.json
  def create
    @article_subcategory = ArticleSubcategory.new(article_subcategory_params)

    respond_to do |format|
      if @article_subcategory.save
        format.html { redirect_to @article_subcategory, notice: 'Article sub category was successfully created.' }
        format.json { render :show, status: :created, location: @article_subcategory }
      else
        format.html { render :new }
        format.json { render json: @article_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_subcategories/1
  # PATCH/PUT /article_subcategories/1.json
  def update
    respond_to do |format|
      if @article_subcategory.update(article_subcategory_params)
        format.html { redirect_to @article_subcategory, notice: 'Article sub category was successfully updated.' }
        format.json { render :show, status: :ok, location: @article_subcategory }
      else
        format.html { render :edit }
        format.json { render json: @article_subcategory.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_subcategories/1
  # DELETE /article_subcategories/1.json
  def destroy
    @article_subcategory.destroy
    respond_to do |format|
      format.html { redirect_to article_subcategories_url, notice: 'Article sub category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_subcategory
      @article_subcategory = ArticleSubcategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_subcategory_params
      params.require(:article_subcategory).permit(:name, :code)
    end
end
