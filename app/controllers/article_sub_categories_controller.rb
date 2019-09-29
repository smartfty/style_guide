class ArticleSubCategoriesController < ApplicationController
  before_action :set_article_sub_category, only: [:show, :edit, :update, :destroy]

  # GET /article_sub_categories
  # GET /article_sub_categories.json
  def index
    @article_sub_categories = ArticleSubCategory.all
  end

  # GET /article_sub_categories/1
  # GET /article_sub_categories/1.json
  def show
  end

  # GET /article_sub_categories/new
  def new
    @article_sub_category = ArticleSubCategory.new
  end

  # GET /article_sub_categories/1/edit
  def edit
  end

  # POST /article_sub_categories
  # POST /article_sub_categories.json
  def create
    @article_sub_category = ArticleSubCategory.new(article_sub_category_params)

    respond_to do |format|
      if @article_sub_category.save
        format.html { redirect_to @article_sub_category, notice: 'Article sub category was successfully created.' }
        format.json { render :show, status: :created, location: @article_sub_category }
      else
        format.html { render :new }
        format.json { render json: @article_sub_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /article_sub_categories/1
  # PATCH/PUT /article_sub_categories/1.json
  def update
    respond_to do |format|
      if @article_sub_category.update(article_sub_category_params)
        format.html { redirect_to @article_sub_category, notice: 'Article sub category was successfully updated.' }
        format.json { render :show, status: :ok, location: @article_sub_category }
      else
        format.html { render :edit }
        format.json { render json: @article_sub_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /article_sub_categories/1
  # DELETE /article_sub_categories/1.json
  def destroy
    @article_sub_category.destroy
    respond_to do |format|
      format.html { redirect_to article_sub_categories_url, notice: 'Article sub category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article_sub_category
      @article_sub_category = ArticleSubCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_sub_category_params
      params.require(:article_sub_category).permit(:name, :code)
    end
end
